import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'custom_card.dart';

class VirtualDisplayCard extends StatelessWidget {
  const VirtualDisplayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSectionCard(
      title: 'Virtual Display',
      icon: Icons.tv_rounded,
      accentColor: AppTheme.blueAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: New Display, Resolution, Don't Destroy Content
          Row(
            children: [
              Expanded(
                child: _buildCheckboxTile('New Display', false, (v) {}),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: '1920x1080',
                  decoration: const InputDecoration(hintText: 'Resolution', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '1920x1080', child: Text('1920x1080 (FHD)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '1280x720', child: Text('1280x720 (HD)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '2560x1440', child: Text('2560x1440 (2K)', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckboxTile("Don't Destroy Content", false, (v) {}),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: No Display Decorations, Dots Per Inch (DPI)
          Row(
            children: [
              Expanded(
                child: _buildCheckboxTile('No Display Decorations', false, (v) {}),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Dots Per Inch (DPI)', isDense: true),
                  keyboardType: TextInputType.number,
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
