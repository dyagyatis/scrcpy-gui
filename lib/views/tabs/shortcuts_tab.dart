import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ShortcutsTab extends StatelessWidget {
  const ShortcutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hasDev = state.selectedSerial != null;

    final shortcuts = [
      {'key': 'MOD + f', 'desc': 'Switch to fullscreen mode'},
      {'key': 'MOD + Left / Right', 'desc': 'Rotate device display left/right'},
      {'key': 'MOD + g', 'desc': 'Resize window to 1:1 pixel perfect'},
      {'key': 'MOD + w / Double Click', 'desc': 'Resize window to remove black borders'},
      {'key': 'MOD + h / Middle Click', 'desc': 'Press HOME button'},
      {'key': 'MOD + b / Right Click', 'desc': 'Press BACK button'},
      {'key': 'MOD + s', 'desc': 'Press APP SWITCHER button'},
      {'key': 'MOD + m', 'desc': 'Press MENU button'},
      {'key': 'MOD + Up / Down', 'desc': 'Increase / decrease volume'},
      {'key': 'MOD + p', 'desc': 'Press POWER button (turn screen on/off)'},
      {'key': 'MOD + o', 'desc': 'Turn device physical screen OFF (mirroring continues)'},
      {'key': 'MOD + Shift + o', 'desc': 'Turn device physical screen ON'},
      {'key': 'MOD + n', 'desc': 'Expand notification panel'},
      {'key': 'MOD + Shift + n', 'desc': 'Collapse notification panel'},
      {'key': 'MOD + c', 'desc': 'Copy device clipboard to PC'},
      {'key': 'MOD + v', 'desc': 'Paste PC clipboard to device'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.keyboard_alt_outlined, color: AppTheme.purpleAccent, size: 24),
              SizedBox(width: 10),
              Text(
                'Scrcpy Keyboard Shortcuts & Remote Controls',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Default MOD key is Alt (Windows/Linux) or Command (macOS). Use these shortcuts while the Scrcpy window is active.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // On-Screen Virtual Navigation Bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🎮 Remote Control Buttons',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildBtn('⚡ Power', 26, state, hasDev),
                    _buildBtn('🏠 Home', 3, state, hasDev),
                    _buildBtn('🔙 Back', 4, state, hasDev),
                    _buildBtn('📋 Apps', 187, state, hasDev),
                    _buildBtn('🔉 Vol -', 25, state, hasDev),
                    _buildBtn('🔊 Vol +', 24, state, hasDev),
                    _buildBtn('🔇 Mute', 164, state, hasDev),
                    _buildBtn('📷 Camera', 27, state, hasDev),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Shortcuts Table
          Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shortcuts.length,
              separatorBuilder: (_, __) => const Divider(color: AppTheme.borderColor, height: 1),
              itemBuilder: (context, idx) {
                final s = shortcuts[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.bgInput,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Text(
                          s['key']!,
                          style: const TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.purpleAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          s['desc']!,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                        ),
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

  Widget _buildBtn(String label, int keycode, AppState state, bool hasDev) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.bgInput,
        foregroundColor: AppTheme.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: !hasDev ? null : () => state.adb.sendKey(state.selectedSerial!, keycode),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
