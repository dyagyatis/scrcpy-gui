import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class AudioSettingsView extends StatelessWidget {
  const AudioSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Параметры трансляции звука (Android 11+)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF93C5FD),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    title: const Text('Включить трансляцию звука на компьютер', style: TextStyle(fontSize: 13)),
                    value: cfg.enableAudio,
                    onChanged: (v) {
                      cfg.enableAudio = v;
                      state.saveSettings();
                    },
                  ),
                  const Divider(color: AppTheme.borderColor),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 220,
                        child: Text('Аудиокодек:', style: TextStyle(fontSize: 13)),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: cfg.audioCodec,
                          decoration: const InputDecoration(isDense: true),
                          dropdownColor: AppTheme.bgCard,
                          items: const [
                            DropdownMenuItem(value: 'opus', child: Text('OPUS (Низкая задержка)')),
                            DropdownMenuItem(value: 'aac', child: Text('AAC (Совместимый)')),
                            DropdownMenuItem(value: 'flac', child: Text('FLAC (Без потерь)')),
                            DropdownMenuItem(value: 'raw', child: Text('RAW (PCM)')),
                          ],
                          onChanged: cfg.enableAudio
                              ? (v) {
                                  if (v != null) {
                                    cfg.audioCodec = v;
                                    state.saveSettings();
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(
                        width: 220,
                        child: Text('Битрейт аудио:', style: TextStyle(fontSize: 13)),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: cfg.audioBitRate,
                          decoration: const InputDecoration(isDense: true),
                          dropdownColor: AppTheme.bgCard,
                          items: const [
                            DropdownMenuItem(value: 64, child: Text('64 Кбит/с')),
                            DropdownMenuItem(value: 128, child: Text('128 Кбит/с (Стандарт)')),
                            DropdownMenuItem(value: 192, child: Text('192 Кбит/с (Высокий)')),
                            DropdownMenuItem(value: 320, child: Text('320 Кбит/с (Максимальный)')),
                          ],
                          onChanged: cfg.enableAudio
                              ? (v) {
                                  if (v != null) {
                                    cfg.audioBitRate = v;
                                    state.saveSettings();
                                  }
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: const Text('Заглушить динамик телефона при трансляции', style: TextStyle(fontSize: 13)),
                    value: cfg.muteDeviceAudio,
                    onChanged: cfg.enableAudio
                        ? (v) {
                            cfg.muteDeviceAudio = v;
                            state.saveSettings();
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
