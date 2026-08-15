import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.settings_outlined, color: AppTheme.purpleAccent, size: 24),
              SizedBox(width: 10),
              Text(
                'Application Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure Scrcpy and ADB binary paths, auto-download tools, default folders, and application behavior.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // 1. Binary Paths Card
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
                        state.isBinaryReady ? '✅ Ready' : '⚠️ Missing',
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
                      label: const Text('Test Availability'),
                      onPressed: () async {
                        final ok = await state.adb.isAvailable();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok ? '✅ Scrcpy & ADB are ready and functional!' : '❌ Binaries not found or failed to execute.'),
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
                      label: Text(state.isDownloading ? 'Downloading...' : '📥 1-Click Auto-Download Scrcpy v4.1'),
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

          // 2. Directories Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('📁 Default Save Folders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(labelText: 'Screenshots Folder', hintText: '~/Pictures/ScrcpyScreenshots', isDense: true),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Screen Recordings Folder', hintText: '~/Videos/ScrcpyRecordings', isDense: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. About Card
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
                  children: const [
                    Text('Scrcpy GUI Flutter', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 2),
                    Text('Version 1.3.0 • Cross-Platform (Windows, Linux, macOS)', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
