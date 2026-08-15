import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ToolsView extends StatefulWidget {
  const ToolsView({super.key});

  @override
  State<ToolsView> createState() => _ToolsViewState();
}

class _ToolsViewState extends State<ToolsView> {
  final TextEditingController _apkController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();
  String _status = '';

  @override
  void dispose() {
    _apkController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hasDevice = state.selectedSerial != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. APK Installer
          _buildCard(
            title: '📦 Установка приложений (APK)',
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _apkController,
                      decoration: const InputDecoration(
                        hintText: 'Путь к .apk файлу...',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.install_mobile, size: 16),
                    label: const Text('Установить'),
                    onPressed: !hasDevice
                        ? null
                        : () async {
                            final path = _apkController.text.trim();
                            if (path.isEmpty) return;
                            setState(() => _status = '⏳ Установка $path...');
                            final res = await state.adb.installApk(state.selectedSerial!, path);
                            setState(() {
                              _status = res['success'] == true
                                  ? '✅ Приложение успешно установлено!'
                                  : '❌ Ошибка: ${res['message']}';
                            });
                          },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 2. Navigation Keys
          _buildCard(
            title: '🎮 Навигация и клавиши Android',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildKeyBtn('⚡ Питание', 26, state, hasDevice),
                  _buildKeyBtn('🏠 Домой (Home)', 3, state, hasDevice),
                  _buildKeyBtn('🔙 Назад (Back)', 4, state, hasDevice),
                  _buildKeyBtn('🔉 Громкость -', 25, state, hasDevice),
                  _buildKeyBtn('🔊 Громкость +', 24, state, hasDevice),
                  _buildKeyBtn('📋 Меню приложений', 187, state, hasDevice),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 3. Reboot
          _buildCard(
            title: '🔄 Перезагрузка устройства',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: !hasDevice ? null : () => state.adb.reboot(state.selectedSerial!),
                    child: const Text('Обычная перезагрузка'),
                  ),
                  ElevatedButton(
                    onPressed: !hasDevice ? null : () => state.adb.reboot(state.selectedSerial!, mode: 'recovery'),
                    child: const Text('В Recovery'),
                  ),
                  ElevatedButton(
                    onPressed: !hasDevice ? null : () => state.adb.reboot(state.selectedSerial!, mode: 'bootloader'),
                    child: const Text('В Bootloader / Fastboot'),
                  ),
                ],
              ),
            ],
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
    );
  }

  Widget _buildKeyBtn(String label, int keycode, AppState state, bool hasDevice) {
    return ElevatedButton(
      onPressed: !hasDevice ? null : () => state.adb.sendKey(state.selectedSerial!, keycode),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF93C5FD),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
