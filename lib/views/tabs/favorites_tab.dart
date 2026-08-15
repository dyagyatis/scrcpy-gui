import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/preset.dart';
import '../../theme/app_theme.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allPresets = [...Preset.defaultPresets, ...state.userPresets];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: AppTheme.redAccent, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Favorites & Presets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Save Current as Preset'),
                onPressed: () => _showAddPresetDialog(context, state),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Quickly apply or launch optimized configuration profiles for gaming, streaming, webcams, or battery saving.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Grid of Presets
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.55,
            ),
            itemCount: allPresets.length,
            itemBuilder: (context, index) {
              final preset = allPresets[index];
              final isSelected = state.selectedPreset == preset.id;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.purpleActive.withOpacity(0.25) : AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppTheme.purpleAccent : AppTheme.borderColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(preset.icon, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            preset.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.purpleAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('ACTIVE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        if (preset.isCustom) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.redAccent),
                            tooltip: 'Delete custom preset',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => state.deleteCustomPreset(preset.id),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        preset.description,
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.purpleAccent,
                            side: const BorderSide(color: AppTheme.purpleAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            state.applyPreset(preset);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Preset "${preset.name}" applied!')),
                            );
                          },
                          child: const Text('Apply', style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.greenAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            state.applyPreset(preset);
                            state.launchScrcpy();
                          },
                          child: const Text('Launch ▶', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddPresetDialog(BuildContext context, AppState state) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedIcon = '⭐';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.bgCard,
          title: const Text('Save Current Settings as Preset', style: TextStyle(fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Preset Name', hintText: 'e.g. My Ultra Stream'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description', hintText: 'e.g. 1080p 60fps with camera and audio'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Icon: ', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(width: 8),
                  Wrap(
                    spacing: 6,
                    children: ['⭐', '🎮', '📷', '📱', '⚡', '🎬', '🔥'].map((emoji) {
                      final isSel = selectedIcon == emoji;
                      return InkWell(
                        onTap: () => setState(() => selectedIcon = emoji),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.purpleAccent.withOpacity(0.3) : AppTheme.bgInput,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: isSel ? AppTheme.purpleAccent : AppTheme.borderColor),
                          ),
                          child: Text(emoji, style: const TextStyle(fontSize: 16)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.purpleAccent, foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  state.addCustomPreset(
                    name: nameCtrl.text.trim(),
                    description: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : 'Custom user profile',
                    icon: selectedIcon,
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Save Preset'),
            ),
          ],
        ),
      ),
    );
  }
}
