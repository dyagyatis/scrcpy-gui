import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class CustomTitlebar extends StatefulWidget {
  const CustomTitlebar({super.key});

  @override
  State<CustomTitlebar> createState() => _CustomTitlebarState();
}

class _CustomTitlebarState extends State<CustomTitlebar> {
  bool _isMaximized = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final accent = AppTheme.getAccentColor(state.activeAccent);
    final dev = state.currentDevice;

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: state.isOledMode ? AppTheme.bgOled : AppTheme.bgSidebar,
        border: const Border(bottom: BorderSide(color: AppTheme.borderColor, width: 1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          // App Logo Icon
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.smartphone_rounded, color: accent, size: 16),
          ),
          const SizedBox(width: 8),
          // App Name
          Text(
            'Scrcpy GUI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: accent.withOpacity(0.4), width: 0.5),
            ),
            child: Text(
              'v3.1',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: accent),
            ),
          ),
          const SizedBox(width: 12),
          // Active Device status pill in Titlebar
          if (dev != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.bgInput,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, color: AppTheme.greenAccent, size: 7),
                  const SizedBox(width: 5),
                  Text(
                    '${dev.displayName} ${dev.batteryLevel != null ? "(${dev.batteryLevel}%)" : ""}',
                    style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          // Window Control Buttons (Minimize, Maximize, Close)
          _buildWindowButton(
            icon: Icons.remove,
            tooltip: 'Minimize',
            onTap: () {
              // Minimize
            },
          ),
          _buildWindowButton(
            icon: _isMaximized ? Icons.filter_none : Icons.crop_square_rounded,
            tooltip: _isMaximized ? 'Restore' : 'Maximize',
            onTap: () {
              setState(() => _isMaximized = !_isMaximized);
            },
          ),
          _buildWindowButton(
            icon: Icons.close_rounded,
            tooltip: 'Close',
            isClose: true,
            onTap: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWindowButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isClose = false,
  }) {
    return _WindowButtonWidget(
      icon: icon,
      tooltip: tooltip,
      isClose: isClose,
      onTap: onTap,
    );
  }
}

class _WindowButtonWidget extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isClose;
  final VoidCallback onTap;

  const _WindowButtonWidget({
    required this.icon,
    required this.tooltip,
    this.isClose = false,
    required this.onTap,
  });

  @override
  State<_WindowButtonWidget> createState() => _WindowButtonWidgetState();
}

class _WindowButtonWidgetState extends State<_WindowButtonWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.transparent;
    Color iconColor = AppTheme.textSecondary;

    if (_isHovered) {
      if (widget.isClose) {
        bg = AppTheme.redAccent;
        iconColor = Colors.white;
      } else {
        bg = Colors.white.withOpacity(0.1);
        iconColor = Colors.white;
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 38,
            color: bg,
            child: Center(
              child: Icon(widget.icon, size: 14, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
