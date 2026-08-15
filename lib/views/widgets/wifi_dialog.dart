import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class WifiConnectDialog extends StatefulWidget {
  const WifiConnectDialog({super.key});

  @override
  State<WifiConnectDialog> createState() => _WifiConnectDialogState();
}

class _WifiConnectDialogState extends State<WifiConnectDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _pairIpController = TextEditingController();
  final TextEditingController _pairCodeController = TextEditingController();

  String _status = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ipController.dispose();
    _pairIpController.dispose();
    _pairCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Dialog(
      backgroundColor: AppTheme.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.borderColor),
      ),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  '📶 Подключение по Wi-Fi ADB',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Прямое подключение'),
                Tab(text: 'Сопряжение (Android 11+)'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Direct Connect
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'IP адрес и порт (по умолчанию 5555):',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _ipController,
                        decoration: const InputDecoration(
                          hintText: '192.168.1.100:5555',
                          isDense: true,
                        ),
                      ),
                      if (state.recentIps.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text(
                          'Недавние адреса:',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          children: state.recentIps.take(4).map((ip) {
                            return ActionChip(
                              label: Text(ip, style: const TextStyle(fontSize: 11)),
                              backgroundColor: AppTheme.bgInput,
                              onPressed: () => _ipController.text = ip,
                            );
                          }).toList(),
                        ),
                      ],
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : () => _connectDirect(state),
                        icon: const Icon(Icons.bolt, size: 16),
                        label: const Text('Подключиться'),
                      ),
                    ],
                  ),
                  // Tab 2: Pairing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'IP и порт сопряжения (Pairing IP:Port):',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _pairIpController,
                        decoration: const InputDecoration(
                          hintText: '192.168.1.100:38475',
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Код сопряжения (6 цифр):',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _pairCodeController,
                        decoration: const InputDecoration(
                          hintText: '849201',
                          isDense: true,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : () => _pairAndConnect(state),
                        icon: const Icon(Icons.key, size: 16),
                        label: const Text('Выполнить сопряжение (Pair)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _status,
                style: TextStyle(
                  fontSize: 12,
                  color: _status.contains('✅') ? AppTheme.successColor : AppTheme.dangerColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _connectDirect(AppState state) async {
    String target = _ipController.text.trim();
    if (target.isEmpty) return;
    if (!target.contains(':')) target = '$target:5555';

    setState(() {
      _isLoading = true;
      _status = '⏳ Подключение к $target...';
    });

    final res = await state.adb.connectWifi(target);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res['success'] == true) {
          _status = '✅ Успешно подключено к $target!';
          state.addRecentIp(target);
          state.refreshDevices();
        } else {
          _status = '❌ Ошибка подключения: ${res['message']}';
        }
      });
    }
  }

  Future<void> _pairAndConnect(AppState state) async {
    final ip = _pairIpController.text.trim();
    final code = _pairCodeController.text.trim();
    if (ip.isEmpty || code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _status = '⏳ Выполняется сопряжение...';
    });

    final res = await state.adb.pairWifi(ip, code);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res['success'] == true) {
          _status = '✅ Сопряжение выполнено! Переключитесь на прямое подключение.';
          final ipOnly = ip.split(':').first;
          _ipController.text = '$ipOnly:5555';
          _tabController.animateTo(0);
        } else {
          _status = '❌ Ошибка сопряжения: ${res['message']}';
        }
      });
    }
  }
}
