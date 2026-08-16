import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class KeymapItem {
  String keyLabel;
  double xPercent; // 0.0 to 1.0 on virtual screen
  double yPercent;
  String type; // 'button', 'dpad', 'aim'

  KeymapItem({
    required this.keyLabel,
    required this.xPercent,
    required this.yPercent,
    this.type = 'button',
  });
}

class KeymapperTab extends StatefulWidget {
  const KeymapperTab({super.key});

  @override
  State<KeymapperTab> createState() => _KeymapperTabState();
}

class _KeymapperTabState extends State<KeymapperTab> {
  final List<KeymapItem> _keymap = [
    KeymapItem(keyLabel: 'W', xPercent: 0.18, yPercent: 0.65, type: 'dpad'),
    KeymapItem(keyLabel: 'A', xPercent: 0.12, yPercent: 0.75, type: 'dpad'),
    KeymapItem(keyLabel: 'S', xPercent: 0.18, yPercent: 0.85, type: 'dpad'),
    KeymapItem(keyLabel: 'D', xPercent: 0.24, yPercent: 0.75, type: 'dpad'),
    KeymapItem(keyLabel: 'Space', xPercent: 0.85, yPercent: 0.80, type: 'button'),
    KeymapItem(keyLabel: 'R', xPercent: 0.82, yPercent: 0.62, type: 'button'),
    KeymapItem(keyLabel: 'Shift', xPercent: 0.18, yPercent: 0.50, type: 'button'),
    KeymapItem(keyLabel: 'L-Click', xPercent: 0.88, yPercent: 0.45, type: 'button'),
    KeymapItem(keyLabel: 'R-Click', xPercent: 0.75, yPercent: 0.78, type: 'aim'),
  ];

  KeymapItem? _selectedItem;
  double _mouseSensitivity = 1.0;
  bool _enableTouchEmulation = true;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_esports_rounded, color: AppTheme.purpleAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                state.tr('keymapper_title'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purpleAccent,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Key Point'),
                onPressed: () {
                  setState(() {
                    _keymap.add(KeymapItem(keyLabel: 'F', xPercent: 0.5, yPercent: 0.5));
                  });
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.greenAccent,
                  side: const BorderSide(color: AppTheme.greenAccent),
                ),
                icon: const Icon(Icons.save, size: 16),
                label: const Text('Save Profile'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Keymapper profile saved!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Map PC keyboard keys and mouse aim to touch coordinates for mobile gaming (PUBG, COD Mobile, Genshin). Drag points on the phone canvas.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Main Layout: Canvas + Controls
          Expanded(
            child: Row(
              children: [
                // 1. Smartphone Virtual Canvas
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF07080C),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderColor, width: 2),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final h = constraints.maxHeight;

                        return Stack(
                          children: [
                            // Background grid
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.05,
                                child: GridPaper(
                                  color: Colors.white,
                                  divisions: 4,
                                  subdivisions: 2,
                                ),
                              ),
                            ),
                            // Center Notch / Phone indicator
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 80,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: AppTheme.borderColor,
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                                ),
                              ),
                            ),
                            // Keymap draggable buttons
                            ..._keymap.map((item) {
                              final posX = item.xPercent * w - 24;
                              final posY = item.yPercent * h - 24;
                              final isSel = _selectedItem == item;

                              return Positioned(
                                left: posX.clamp(0.0, w - 48),
                                top: posY.clamp(0.0, h - 48),
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      item.xPercent = (item.xPercent + details.delta.dx / w).clamp(0.05, 0.95);
                                      item.yPercent = (item.yPercent + details.delta.dy / h).clamp(0.05, 0.95);
                                    });
                                  },
                                  onTap: () => setState(() => _selectedItem = item),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSel
                                          ? AppTheme.yellowAccent.withOpacity(0.8)
                                          : item.type == 'dpad'
                                              ? AppTheme.purpleAccent.withOpacity(0.7)
                                              : item.type == 'aim'
                                                  ? AppTheme.redAccent.withOpacity(0.7)
                                                  : AppTheme.blueAccent.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: isSel ? 2 : 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        item.keyLabel,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. Settings Panel on the Right
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Selected Key Editor
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.bgCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('🎯 Key Point Properties', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 12),
                              if (_selectedItem != null) ...[
                                TextField(
                                  controller: TextEditingController(text: _selectedItem!.keyLabel),
                                  decoration: const InputDecoration(labelText: 'Key Label / Shortcut', isDense: true),
                                  onChanged: (v) => setState(() => _selectedItem!.keyLabel = v),
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  value: _selectedItem!.type,
                                  decoration: const InputDecoration(labelText: 'Action Type', isDense: true),
                                  dropdownColor: AppTheme.bgCard,
                                  items: const [
                                    DropdownMenuItem(value: 'button', child: Text('Touch Tap (Button)')),
                                    DropdownMenuItem(value: 'dpad', child: Text('Movement (WASD)')),
                                    DropdownMenuItem(value: 'aim', child: Text('Mouse Aim (FPS)')),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) setState(() => _selectedItem!.type = v);
                                  },
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.redAccent, foregroundColor: Colors.white),
                                  icon: const Icon(Icons.delete, size: 14),
                                  label: const Text('Delete Point'),
                                  onPressed: () {
                                    setState(() {
                                      _keymap.remove(_selectedItem);
                                      _selectedItem = null;
                                    });
                                  },
                                ),
                              ] else ...[
                                const Text('Click any button on the phone canvas to edit its properties.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Sensitivity & Global Options
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.bgCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('⚙️ Aim & Touch Options', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              const SizedBox(height: 12),
                              Text('Mouse Aim Sensitivity (${_mouseSensitivity.toStringAsFixed(1)}x):', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                              Slider(
                                value: _mouseSensitivity,
                                min: 0.2,
                                max: 3.0,
                                divisions: 28,
                                onChanged: (v) => setState(() => _mouseSensitivity = v),
                              ),
                              SwitchListTile(
                                title: const Text('Enable Hardware Mouse Lock', style: TextStyle(fontSize: 12)),
                                value: _enableTouchEmulation,
                                onChanged: (v) => setState(() => _enableTouchEmulation = v),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
