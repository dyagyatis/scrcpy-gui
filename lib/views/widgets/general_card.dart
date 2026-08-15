import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';
import 'custom_card.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final cfg = state.config;

    return CustomSectionCard(
      title: 'General & Video Source',
      icon: Icons.computer_rounded,
      accentColor: AppTheme.orangeAccent,
      onReset: () {
        cfg.videoSource = 'display';
        cfg.cameraFacing = 'back';
        cfg.fullscreen = false;
        cfg.turnScreenOff = false;
        cfg.stayAwake = true;
        cfg.borderless = false;
        cfg.alwaysOnTop = false;
        cfg.windowTitle = '';
        cfg.bitRate = 8;
        cfg.maxFps = '0';
        cfg.maxSize = '0';
        state.saveSettings();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Video Source Mode: Display vs Camera (Webcam)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.bgInput,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.videocam_outlined, size: 16, color: AppTheme.yellowAccent),
                const SizedBox(width: 8),
                const Text('Video Source:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('📱 Screen Mirroring', style: TextStyle(fontSize: 11)),
                  selected: cfg.videoSource == 'display',
                  selectedColor: AppTheme.purpleAccent.withOpacity(0.3),
                  onSelected: (sel) {
                    if (sel) {
                      cfg.videoSource = 'display';
                      state.saveSettings();
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('📷 Camera (PC Webcam)', style: TextStyle(fontSize: 11)),
                  selected: cfg.videoSource == 'camera',
                  selectedColor: AppTheme.yellowAccent.withOpacity(0.3),
                  onSelected: (sel) {
                    if (sel) {
                      cfg.videoSource = 'camera';
                      state.saveSettings();
                    }
                  },
                ),
              ],
            ),
          ),
          if (cfg.videoSource == 'camera') ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: cfg.cameraFacing,
                    decoration: const InputDecoration(labelText: 'Camera Facing', isDense: true),
                    dropdownColor: AppTheme.bgCard,
                    items: const [
                      DropdownMenuItem(value: 'back', child: Text('Back Camera (Main)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'front', child: Text('Front Camera (Selfie)', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        cfg.cameraFacing = v;
                        state.saveSettings();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: cfg.cameraFps.isEmpty ? '60' : cfg.cameraFps,
                    decoration: const InputDecoration(labelText: 'Camera FPS', isDense: true),
                    dropdownColor: AppTheme.bgCard,
                    items: const [
                      DropdownMenuItem(value: '60', child: Text('60 FPS (Smooth)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: '30', child: Text('30 FPS', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        cfg.cameraFps = v;
                        state.saveSettings();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),

          // Row 1: Window Title, Fullscreen, Screen Off
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: cfg.windowTitle,
                  decoration: const InputDecoration(hintText: 'Window Title', isDense: true),
                  onChanged: (v) {
                    cfg.windowTitle = v;
                    state.saveSettings();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildCheckboxTile('Fullscreen', cfg.fullscreen, (v) {
                  cfg.fullscreen = v ?? false;
                  state.saveSettings();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildCheckboxTile('Screen off', cfg.turnScreenOff, (v) {
                  cfg.turnScreenOff = v ?? false;
                  state.saveSettings();
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: Stay Awake, Crop Screen, Orientation
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildCheckboxTile('Stay Awake', cfg.stayAwake, (v) {
                  cfg.stayAwake = v ?? false;
                  state.saveSettings();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: const InputDecoration(hintText: 'Crop Screen (W:H:X:Y)', isDense: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: cfg.orientation,
                  decoration: const InputDecoration(hintText: 'Orientation', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('Auto Orientation', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '90', child: Text('90°', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '180', child: Text('180°', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '270', child: Text('270°', style: TextStyle(fontSize: 12))),
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
          const SizedBox(height: 8),

          // Row 3: Window Borderless, Window Always on Top, Disable Screensaver
          Row(
            children: [
              Expanded(
                child: _buildCheckboxTile('Window Borderless', cfg.borderless, (v) {
                  cfg.borderless = v ?? false;
                  state.saveSettings();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckboxTile('Window Always on Top', cfg.alwaysOnTop, (v) {
                  cfg.alwaysOnTop = v ?? false;
                  state.saveSettings();
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCheckboxTile('Disable Screensaver', true, (v) {}),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 4: Video Bit Rate, Max FPS, Max Size
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: cfg.bitRate,
                  decoration: const InputDecoration(hintText: 'Video Bit Rate', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: 4, child: Text('4 Mbps', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 8, child: Text('8 Mbps (Default)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 12, child: Text('12 Mbps', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 16, child: Text('16 Mbps (High)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: 24, child: Text('24 Mbps (Max)', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.bitRate = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: cfg.maxFps,
                  decoration: const InputDecoration(hintText: 'Max FPS', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('Max FPS (Unlimited)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '30', child: Text('30 FPS', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '60', child: Text('60 FPS', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '90', child: Text('90 FPS', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '120', child: Text('120 FPS', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.maxFps = v;
                      state.saveSettings();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: cfg.maxSize,
                  decoration: const InputDecoration(hintText: 'Max Size', isDense: true),
                  dropdownColor: AppTheme.bgCard,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('Max Size (Original)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '1920', child: Text('1080p (1920)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '1280', child: Text('720p (1280)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: '854', child: Text('480p (854)', style: TextStyle(fontSize: 12))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      cfg.maxSize = v;
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
