import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import '../../services/update_service.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _isCheckingUpdate = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings_outlined, color: AppTheme.purpleAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                state.tr('settings'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure Scrcpy and ADB binary paths, auto-download tools, language, and updates.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // 1. Language Selection Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.language_rounded, size: 20, color: AppTheme.purpleAccent),
                const SizedBox(width: 10),
                Text(state.tr('language'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const Spacer(),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'ru', label: Text('🇷🇺 Русский')),
                    ButtonSegment(value: 'en', label: Text('🇬🇧 English')),
                  ],
                  selected: {state.language},
                  onSelectionChanged: (set) {
                    if (set.isNotEmpty) state.setLanguage(set.first);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Binary Paths Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('⚙️ Scrcpy & ADB Executables', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: state.isBinaryReady ? AppTheme.greenAccent.withOpacity(0.15) : AppTheme.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: state.isBinaryReady ? AppTheme.greenAccent : AppTheme.redAccent),
                      ),
                      child: Text(
                        state.isBinaryReady ? '✅ ${state.tr("ready")}' : '⚠️ ${state.tr("missing")}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: state.isBinaryReady ? AppTheme.greenAccent : AppTheme.redAccent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: state.scrcpyPath ?? 'scrcpy',
                  decoration: const InputDecoration(labelText: 'Scrcpy Binary Path', isDense: true),
                  onChanged: (v) {
                    state.scrcpyPath = v;
                    state.scrcpy.scrcpyPath = v;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: state.adbPath ?? 'adb',
                  decoration: const InputDecoration(labelText: 'ADB Binary Path', isDense: true),
                  onChanged: (v) {
                    state.adbPath = v;
                    state.adb.adbPath = v;
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.purpleAccent,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: Text(state.tr('test_availability')),
                      onPressed: () async {
                        final ok = await state.adb.isAvailable();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok ? '✅ Scrcpy & ADB are functional!' : '❌ Binaries not found.'),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.greenAccent,
                        foregroundColor: Colors.white,
                      ),
                      icon: state.isDownloading
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.download_rounded, size: 16),
                      label: Text(state.isDownloading ? state.tr('downloading') : state.tr('auto_download_btn')),
                      onPressed: state.isDownloading ? null : () => state.downloadScrcpyBinaries(),
                    ),
                  ],
                ),
                if (state.downloadStatus.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    state.downloadStatus,
                    style: TextStyle(
                      fontSize: 12,
                      color: state.downloadStatus.contains('✅') ? AppTheme.greenAccent : AppTheme.yellowAccent,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. About & Updates Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                const Text('⚡', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Scrcpy GUI Flutter', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('Version ${UpdateService.currentVersion} • Master Release', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.bgInput,
                    foregroundColor: AppTheme.purpleAccent,
                    side: const BorderSide(color: AppTheme.purpleAccent),
                  ),
                  icon: _isCheckingUpdate
                      ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.update_rounded, size: 16),
                  label: Text(state.tr('check_updates')),
                  onPressed: _isCheckingUpdate ? null : () => _checkForUpdates(state),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkForUpdates(AppState state) async {
    setState(() => _isCheckingUpdate = true);
    final info = await state.updater.checkForUpdates();
    if (mounted) {
      setState(() => _isCheckingUpdate = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.bgCard,
          title: Text(info.hasUpdate ? '🎉 New Version Available!' : '✅ Up to Date'),
          content: Text(
            info.hasUpdate
                ? 'Latest release: ${info.tagName}\nYou are currently on: ${UpdateService.currentVersion}\n\nVisit GitHub Releases to download.'
                : 'You are using the latest version of Scrcpy GUI (${UpdateService.currentVersion})!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
