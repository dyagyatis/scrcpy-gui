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
    final presets = Preset.defaultPresets;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.favorite_rounded, color: AppTheme.redAccent, size: 24),
              SizedBox(width: 10),
              Text(
                'Favorites & Presets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Quickly apply or launch optimized configuration profiles for different use cases.',
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
              childAspectRatio: 1.6,
            ),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final preset = presets[index];
              final isSelected = state.selectedPreset == preset.id;

              return Container(
                padding: const EdgeInsets.all(16),
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
                        Text(preset.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            preset.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.purpleAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('ACTIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        preset.description,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.purpleAccent,
                            side: const BorderSide(color: AppTheme.purpleAccent),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            state.applyPreset(preset);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Preset "${preset.name}" applied!')),
                            );
                          },
                          child: const Text('Apply', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.greenAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            state.applyPreset(preset);
                            state.launchScrcpy();
                          },
                          child: const Text('Launch ▶', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
}
