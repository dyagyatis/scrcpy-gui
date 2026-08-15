import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class AppDrawerTab extends StatefulWidget {
  const AppDrawerTab({super.key});

  @override
  State<AppDrawerTab> createState() => _AppDrawerTabState();
}

class _AppDrawerTabState extends State<AppDrawerTab> {
  List<String> _packages = [];
  String _searchQuery = '';
  bool _isLoading = false;
  final TextEditingController _apkPathController = TextEditingController();
  String _statusMsg = '';

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  @override
  void dispose() {
    _apkPathController.dispose();
    super.dispose();
  }

  Future<void> _loadPackages() async {
    final state = context.read<AppState>();
    if (state.selectedSerial == null) return;

    setState(() => _isLoading = true);
    final res = await state.adb.runAdb([
      if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
      'shell',
      'pm',
      'list',
      'packages',
      '-3',
    ]);

    if (mounted) {
      if (res.exitCode == 0) {
        final lines = res.stdout.toString().split('\n');
        final pkgs = lines
            .where((l) => l.startsWith('package:'))
            .map((l) => l.replaceFirst('package:', '').trim())
            .toList();
        setState(() {
          _packages = pkgs..sort();
          _isLoading = false;
        });
      } else {
        setState(() {
          _packages = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final filtered = _packages
        .where((p) => p.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: AppTheme.yellowAccent, size: 24),
              const SizedBox(width: 10),
              const Text(
                'App Drawer (Installed 3rd Party Apps)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.bgCard,
                  foregroundColor: AppTheme.textPrimary,
                ),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh Apps', style: TextStyle(fontSize: 12)),
                onPressed: state.selectedSerial != null ? _loadPackages : null,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // APK Quick Installer Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _apkPathController,
                    decoration: const InputDecoration(
                      hintText: 'Enter absolute path to .apk file or drag & drop here...',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.install_mobile, size: 16),
                  label: const Text('Install APK'),
                  onPressed: state.selectedSerial == null
                      ? null
                      : () async {
                          final path = _apkPathController.text.trim();
                          if (path.isEmpty) return;
                          setState(() => _statusMsg = 'Installing $path...');
                          final res = await state.adb.installApk(state.selectedSerial!, path);
                          setState(() {
                            _statusMsg = res['success'] == true ? '✅ App installed successfully!' : '❌ Error: ${res['message']}';
                          });
                          _loadPackages();
                        },
                ),
              ],
            ),
          ),
          if (_statusMsg.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_statusMsg, style: const TextStyle(fontSize: 12, color: AppTheme.greenAccent)),
          ],
          const SizedBox(height: 14),

          // Search Field
          TextField(
            decoration: const InputDecoration(
              hintText: 'Filter installed applications...',
              prefixIcon: Icon(Icons.search, size: 18, color: AppTheme.textMuted),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 14),

          // Apps List
          Expanded(
            child: state.selectedSerial == null
                ? const Center(
                    child: Text('No Android device selected. Connect a device first.', style: TextStyle(color: AppTheme.textMuted)),
                  )
                : _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? const Center(child: Text('No applications found.', style: TextStyle(color: AppTheme.textMuted)))
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(color: AppTheme.borderColor, height: 1),
                            itemBuilder: (context, idx) {
                              final pkg = filtered[idx];
                              return ListTile(
                                leading: const Icon(Icons.android, color: AppTheme.greenAccent),
                                title: Text(pkg, style: const TextStyle(fontSize: 13, color: Colors.white)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.play_arrow, color: AppTheme.greenAccent, size: 20),
                                      tooltip: 'Launch App',
                                      onPressed: () async {
                                        await state.adb.runAdb([
                                          if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
                                          'shell',
                                          'monkey',
                                          '-p',
                                          pkg,
                                          '-c',
                                          'android.intent.category.LAUNCHER',
                                          '1',
                                        ]);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Launched $pkg')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
