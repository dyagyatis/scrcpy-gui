import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import 'custom_card.dart';

class RecordingCard extends StatelessWidget {
  const RecordingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return CustomSectionCard(
      title: 'Recording',
      icon: Icons.videocam_rounded,
      accentColor: AppTheme.redAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCheckboxTile('Record Screen', cfg.recordEnabled, (v) {
                  cfg.recordEnabled = v ?? false;
                  state.saveSettings();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: cfg.recordFormat,
                  decoration: const InputDecoration(hintText: 'Format', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 'mp4', child: Text('MP4 (Default)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 'mkv', child: Text('MKV', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.recordFormat = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckboxTile('Record Audio Only', false, (v) {}),
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
