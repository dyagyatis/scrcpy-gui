import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import 'wifi_dialog.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final selectedDev = state.devices.where((d) => d.serial == state.selectedSerial).firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Text(
              '📱 Устройство:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: state.devices.isEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.bgInput,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: const Text(
                        '⚠️ Устройства не найдены',
                        style: TextStyle(color: Color(0xFFF59E0B), fontSize: 13),
                      ),
                    )
                  : DropdownButtonFormField<String>(
                      value: state.selectedSerial,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      dropdownColor: AppTheme.bgCard,
                      items: state.devices.map((dev) {
                        return DropdownMenuItem<String>(
                          value: dev.serial,
                          child: Text(
                            dev.displayName,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) state.selectDevice(val);
                      },
                    ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              tooltip: 'Обновить список устройств',
              onPressed: () => state.refreshDevices(),
            ),
            const SizedBox(width: 4),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              icon: const Icon(Icons.wifi, size: 16),
              label: const Text('Wi-Fi ADB', style: TextStyle(fontSize: 12)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const WifiConnectDialog(),
                );
              },
            ),
            if (selectedDev != null && !selectedDev.isWifi) ...[
              const SizedBox(width: 6),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                icon: const Icon(Icons.cable, size: 16),
                label: const Text('Включить TCP/IP', style: TextStyle(fontSize: 12)),
                onPressed: () async {
                  final res = await state.adb.enableTcpIp(selectedDev.serial);
                  final ip = await state.adb.getDeviceIp(selectedDev.serial);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['success'] == true
                            ? '✅ TCP/IP включен! IP: ${ip ?? "порт 5555"}'
                            : '❌ Ошибка: ${res['message']}'),
                      ),
                    );
                    state.refreshDevices();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
