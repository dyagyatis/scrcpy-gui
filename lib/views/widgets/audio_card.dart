import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import 'custom_card.dart';

class AudioCard extends StatelessWidget {
  const AudioCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return CustomSectionCard(
      title: 'Audio',
      icon: Icons.headphones_rounded,
      accentColor: AppTheme.greenAccent,
      onReset: () {
        cfg.enableAudio = true;
        cfg.audioCodec = 'opus';
        cfg.audioBitRate = 128;
        cfg.audioBuffer = 50;
        cfg.muteDeviceAudio = false;
        state.saveSettings();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Audio Bit Rate, Audio Buffer, Audio Codec Options
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: cfg.audioBitRate,
                  decoration: const InputDecoration(hintText: 'Audio Bit Rate', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 64, child: Text('64 kbps', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 128, child: Text('128 kbps (Default)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 192, child: Text('192 kbps', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 320, child: Text('320 kbps', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.audioBitRate = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: cfg.audioBuffer.toString(),
                  decoration: const InputDecoration(hintText: 'Audio Buffer (ms)', isDense: true),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    cfg.audioBuffer = int.tryParse(v) ?? 50;
                    state.saveSettings();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: cfg.audioCodec,
                  decoration: const InputDecoration(hintText: 'Audio Codec Options', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 'opus', child: Text('OPUS (Default)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'aac', child: Text('AAC', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'flac', child: Text('FLAC (Lossless)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'raw', child: Text('RAW', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.audioCodec = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Audio Source, No Audio, Audio Duplication
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: 'output',
                  decoration: const InputDecoration(hintText: 'Audio Source', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 'output', child: Text('Output (Device Audio)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'mic', child: Text('Microphone', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildCheckboxTile('No Audio', !cfg.enableAudio, (v) {
                  cfg.enableAudio = !(v ?? false);
                  state.saveSettings();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildCheckboxTile('Audio Duplication', !cfg.muteDeviceAudio, (v) {
                  cfg.muteDeviceAudio = !(v ?? false);
                  state.saveSettings();
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 3: Audio Codec - Encoder
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: 'auto',
                  decoration: const InputDecoration(hintText: 'Audio Codec - Encoder', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text('Auto Encoder Selection', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool value, Function(bool?) onChanged) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.bgInput,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
