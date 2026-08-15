import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import 'wifi_dialog.dart';

class CommandCard extends StatelessWidget {
  final VoidCallback? onFavorite;

  const CommandCard({super.key, this.onFavorite});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isRunning = state.isCurrentDeviceRunning();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.purpleAccent.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
              border: Border(
                bottom: BorderSide(color: AppTheme.purpleAccent.withOpacity(0.3), width: 1),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.terminal_rounded, size: 18, color: AppTheme.purpleAccent),
                SizedBox(width: 8),
                Text(
                  'Command',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.purpleAccent,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Command Preview Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.bgInput,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          state.commandPreview,
                          style: const TextStyle(
                            fontFamily: 'Consolas',
                            fontSize: 12,
                            color: Color(0xFFF1F5F9),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 16, color: AppTheme.textSecondary),
                        tooltip: 'Copy Command',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: state.commandPreview));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Command copied to clipboard')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.download_rounded, size: 16, color: AppTheme.textSecondary),
                        tooltip: 'Save preset',
                        onPressed: onFavorite,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Actions & Device Selection Bar
                Row(
                  children: [
                    // Device Selector Dropdown
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.bgInput,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.selectedSerial,
                            isExpanded: true,
                            hint: const Text('Select Device', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            dropdownColor: AppTheme.bgCard,
                            items: state.devices.map((dev) {
                              return DropdownMenuItem<String>(
                                value: dev.serial,
                                child: Text(
                                  dev.displayName,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) state.selectDevice(val);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Run / Stop Button (Green / Red)
                    InkWell(
                      onTap: () {
                        if (isRunning) {
                          state.stopScrcpy();
                        } else {
                          state.launchScrcpy();
                        }
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 42,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isRunning ? AppTheme.redAccent : AppTheme.greenAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Favorite / Heart Button (Red)
                    InkWell(
                      onTap: onFavorite,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 42,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.redAccent.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Port Input Box
                    Container(
                      width: 75,
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.bgInput,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: Center(
                        child: Text(
                          '5555',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Wi-Fi Button
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const WifiConnectDialog(),
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 42,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.bgInput,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: const Icon(
                          Icons.wifi_rounded,
                          color: AppTheme.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Clear / Disconnect Button
                    InkWell(
                      onTap: () {
                        state.refreshDevices();
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 42,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppTheme.bgInput,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppTheme.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
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
