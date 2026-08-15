import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class RecordSettingsView extends StatefulWidget {
  const RecordSettingsView({super.key});

  @override
  State<RecordSettingsView> createState() => _RecordSettingsViewState();
}

class _RecordSettingsViewState extends State<RecordSettingsView> {
  String _screenshotStatus = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Recording
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Запись видеопотока',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF93C5FD),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    title: const Text('Записывать экран при старте Scrcpy', style: TextStyle(fontSize: 13)),
                    value: cfg.recordEnabled,
                    onChanged: (v) {
                      cfg.recordEnabled = v;
                      state.saveSettings();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 220,
                        child: Text('Формат контейнера:', style: TextStyle(fontSize: 13)),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: cfg.recordFormat,
                          decoration: const InputDecoration(isDense: true),
                          dropdownColor: AppTheme.bgCard,
                          items: const [
                            DropdownMenuItem(value: 'mp4', child: Text('MP4 (Рекомендуемый)')),
                            DropdownMenuItem(value: 'mkv', child: Text('MKV (Устойчив к обрывам)')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              cfg.recordFormat = v;
                              state.saveSettings();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Instant Screenshot
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Скриншоты через ADB',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF93C5FD),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text('📸 Сделать мгновенный снимок экрана'),
                    onPressed: state.selectedSerial == null
                        ? null
                        : () async {
                            final serial = state.selectedSerial!;
                            final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
                            final home = Platform.environment['USERPROFILE'] ?? '.';
                            final path = '$home/Pictures/ScrcpyScreenshots/scrcpy_${serial.replaceAll(':', '_')}_$now.png';
                            setState(() => _screenshotStatus = '⏳ Сохранение...');
                            final res = await state.adb.takeScreenshot(serial, path);
                            setState(() {
                              _screenshotStatus = res['success'] == true
                                  ? '✅ Сохранено: $path'
                                  : '❌ Ошибка: ${res['message']}';
                            });
                          },
                  ),
                  if (_screenshotStatus.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      _screenshotStatus,
                      style: TextStyle(
                        fontSize: 12,
                        color: _screenshotStatus.contains('✅') ? AppTheme.successColor : AppTheme.dangerColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
