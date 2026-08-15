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
            'Configure Scrcpy and ADB binary paths, default capture directories, and application behavior.',
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
                const Text('⚙️ Scrcpy & ADB Executables', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.purpleAccent,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Test Binaries Availability'),
                      onPressed: () async {
                        final ok = await state.adb.isAvailable();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(ok ? '✅ Scrcpy & ADB are ready!' : '❌ Binaries not found or failed to execute.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
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
              children: [
                const Text('📁 Default Save Folders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: '~/Pictures/ScrcpyScreenshots',
                  decoration: const InputDecoration(labelText: 'Screenshots Folder', isDense: true),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: '~/Videos/ScrcpyRecordings',
                  decoration: const InputDecoration(labelText: 'Screen Recordings Folder', isDense: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. About
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
                    Text('Version 1.2.0 • Cross-Platform (Windows, Linux, macOS)', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
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
