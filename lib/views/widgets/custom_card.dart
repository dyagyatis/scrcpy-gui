import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomSectionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget child;
  final VoidCallback? onSave;
  final VoidCallback? onReset;

  const CustomSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.child,
    this.onSave,
    this.onReset,
  });

  @override
  State<CustomSectionCard> createState() => _CustomSectionCardState();
}

class _CustomSectionCardState extends State<CustomSectionCard> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(7),
                bottom: _isCollapsed ? const Radius.circular(7) : Radius.zero,
              ),
              border: Border(
                bottom: _isCollapsed
                    ? BorderSide.none
                    : BorderSide(color: widget.accentColor.withOpacity(0.3), width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 18, color: widget.accentColor),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.accentColor,
                  ),
                ),
                const Spacer(),
                // Save button
                _buildHeaderIcon(
                  icon: Icons.save_outlined,
                  tooltip: 'Save Section',
                  color: widget.accentColor,
                  onTap: widget.onSave,
                ),
                const SizedBox(width: 4),
                // Reset button
                _buildHeaderIcon(
                  icon: Icons.cleaning_services_outlined,
                  tooltip: 'Reset Section',
                  color: widget.accentColor,
                  onTap: widget.onReset,
                ),
                const SizedBox(width: 4),
                // Collapse button
                _buildHeaderIcon(
                  icon: _isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  tooltip: _isCollapsed ? 'Expand' : 'Collapse',
                  color: widget.accentColor,
                  onTap: () => setState(() => _isCollapsed = !_isCollapsed),
                ),
              ],
            ),
          ),
          // Body
          if (!_isCollapsed)
            Padding(
              padding: const EdgeInsets.all(12),
              child: widget.child,
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({
    required IconData icon,
    required String tooltip,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}
