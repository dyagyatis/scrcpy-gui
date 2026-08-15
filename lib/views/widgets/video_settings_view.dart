import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class VideoSettingsView extends StatelessWidget {
  const VideoSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(
            title: 'Параметры видеопотока',
            children: [
              // Max Size
              _buildRow(
                label: 'Разрешение (Макс. размер):',
                child: DropdownButtonFormField<String>(
                  value: cfg.maxSize,
                  decoration: const InputDecoration(isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('Исходное (Без сжатия)')),
                    DropdownMenuItem(value: '1080', child: Text('1080p (Full HD - 1920)')),
                    DropdownMenuItem(value: '1440', child: Text('1440p (2K - 2560)')),
                    DropdownMenuItem(value: '720', child: Text('720p (HD - 1280)')),
                    DropdownMenuItem(value: '480', child: Text('480p (SD - 854)')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.maxSize = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Bitrate
              _buildRow(
                label: 'Битрейт видео (${cfg.bitRate} Мбит/с):',
                child: Slider(
                  value: cfg.bitRate.toDouble(),
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '${cfg.bitRate} Mbps',
                  onChanged: (v) {
                    cfg.bitRate = v.toInt();
                    state.saveSettings();
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Max FPS
              _buildRow(
                label: 'Частота кадров (FPS):',
                child: DropdownButtonFormField<String>(
                  value: cfg.maxFps,
                  decoration: const InputDecoration(isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('Без ограничений (Максимум)')),
                    DropdownMenuItem(value: '120', child: Text('120 кадров/сек')),
                    DropdownMenuItem(value: '90', child: Text('90 кадров/сек')),
                    DropdownMenuItem(value: '60', child: Text('60 кадров/сек')),
                    DropdownMenuItem(value: '30', child: Text('30 кадров/сек')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.maxFps = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Video Codec
              _buildRow(
                label: 'Видеокодек:',
                child: DropdownButtonFormField<String>(
                  value: cfg.videoCodec,
                  decoration: const InputDecoration(isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 'h264', child: Text('H.264 (Стандартный / Совместимый)')),
                    DropdownMenuItem(value: 'h265', child: Text('H.265 / HEVC (Эффективный)')),
                    DropdownMenuItem(value: 'av1', child: Text('AV1 (Современный)')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.videoCodec = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Orientation
              _buildRow(
                label: 'Фиксация поворота:',
                child: DropdownButtonFormField<String>(
                  value: cfg.orientation,
                  decoration: const InputDecoration(isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('Авто (Следовать за телефоном)')),
                    DropdownMenuItem(value: '90', child: Text('Повернуть на 90°')),
                    DropdownMenuItem(value: '180', child: Text('Повернуть на 180°')),
                    DropdownMenuItem(value: '270', child: Text('Повернуть на 270°')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.orientation = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF93C5FD),
              ),
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow({required String label, required Widget child}) {
    return Row(
      children: [
        SizedBox(
          width: 220,
          child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)),
        ),
        Expanded(child: child),
      ],
    );
  }
}
