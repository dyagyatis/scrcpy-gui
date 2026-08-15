import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class ScriptsTab extends StatefulWidget {
  const ScriptsTab({super.key});

  @override
  State<ScriptsTab> createState() => _ScriptsTabState();
}

class _ScriptsTabState extends State<ScriptsTab> {
  String _output = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hasDev = state.selectedSerial != null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.code_rounded, color: AppTheme.purpleAccent, size: 24),
              SizedBox(width: 10),
              Text(
                'ADB Quick Scripts & Automation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Execute essential system commands, battery diagnostics, and reboot procedures directly.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Scripts Grid
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Action buttons
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildScriptCard(
                          title: '🔋 Battery Status & Temperature',
                          description: 'Query battery level, health, voltage, and thermal state',
                          onRun: !hasDev ? null : () => _runCmd(state, ['shell', 'dumpsys', 'battery']),
                        ),
                        _buildScriptCard(
                          title: '📐 Display Specs & Density',
                          description: 'Fetch physical screen resolution (wm size) and density (wm density)',
                          onRun: !hasDev ? null : () => _runCmd(state, ['shell', 'wm', 'size']),
                        ),
                        _buildScriptCard(
                          title: '📶 Network Information',
                          description: 'Show wlan0 IP address, default gateways, and network interfaces',
                          onRun: !hasDev ? null : () => _runCmd(state, ['shell', 'ip', 'addr', 'show', 'wlan0']),
                        ),
                        _buildScriptCard(
                          title: '🔄 Reboot to Recovery',
                          description: 'Reboot device into Recovery Mode (TWRP / Stock Recovery)',
                          isDanger: true,
                          onRun: !hasDev ? null : () => state.adb.reboot(state.selectedSerial!, mode: 'recovery'),
                        ),
                        _buildScriptCard(
                          title: '⚡ Reboot to Bootloader / Fastboot',
                          description: 'Reboot device into Fastboot bootloader for flashing',
                          isDanger: true,
                          onRun: !hasDev ? null : () => state.adb.reboot(state.selectedSerial!, mode: 'bootloader'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Right: Output Terminal
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090A0E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.terminal_rounded, size: 16, color: AppTheme.greenAccent),
                            const SizedBox(width: 6),
                            const Text('Script Output Console', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 14, color: AppTheme.textMuted),
                              onPressed: () => setState(() => _output = ''),
                            ),
                          ],
                        ),
                        const Divider(color: AppTheme.borderColor),
                        Expanded(
                          child: SingleChildScrollView(
                            child: SelectableText(
                              _output.isEmpty ? 'Click any script button on the left to run command...' : _output,
                              style: TextStyle(
                                fontFamily: 'Consolas',
                                fontSize: 11,
                                color: _output.isEmpty ? AppTheme.textMuted : const Color(0xFFA7F3D0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runCmd(AppState state, List<String> args) async {
    setState(() => _output = 'Running: adb ${args.join(' ')}...\n');
    final fullArgs = [
      if (state.selectedSerial != null) ...['-s', state.selectedSerial!],
      ...args,
    ];
    final res = await state.adb.runAdb(fullArgs);
    setState(() {
      _output = res.stdout.toString() + res.stderr.toString();
    });
  }

  Widget _buildScriptCard({
    required String title,
    required String description,
    VoidCallback? onRun,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDanger ? AppTheme.redAccent.withOpacity(0.4) : AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger ? AppTheme.redAccent : AppTheme.purpleAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: onRun,
            child: const Text('Run ▶', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
