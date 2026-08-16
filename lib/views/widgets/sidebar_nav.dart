import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class SidebarNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SidebarNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final accent = AppTheme.getAccentColor(state.activeAccent);
    final width = _isExpanded ? 200.0 : 76.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: width,
      decoration: BoxDecoration(
        color: state.isOledMode ? AppTheme.bgOled : AppTheme.bgSidebar,
        border: const Border(right: BorderSide(color: AppTheme.borderColor, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Sidebar Top Header: Expand / Collapse Toggle + Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: _isExpanded ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: accent.withOpacity(0.5), width: 1.5),
                  ),
                  child: Icon(
                    Icons.smartphone_rounded,
                    color: accent,
                    size: 20,
                  ),
                ),
                if (_isExpanded) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Scrcpy GUI',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black87 : Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.menu_open_rounded : Icons.menu_rounded,
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                  tooltip: _isExpanded ? 'Collapse Sidebar' : 'Expand Sidebar',
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: AppTheme.borderColor, height: 1),
          const SizedBox(height: 8),

          // Nav items list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildNavItem(0, Icons.home_rounded, state.tr('home'), accent),
                  _buildNavItem(1, Icons.favorite_border_rounded, state.tr('favorites'), accent),
                  _buildNavItem(2, Icons.sports_esports_rounded, state.tr('keymapper'), accent),
                  _buildNavItem(3, Icons.folder_shared_rounded, state.tr('files'), accent),
                  _buildNavItem(4, Icons.analytics_rounded, state.tr('monitor'), accent),
                  _buildNavItem(5, Icons.grid_view_rounded, state.tr('app_drawer'), accent, badge: 'BETA'),
                  _buildNavItem(6, Icons.code_rounded, state.tr('scripts'), accent),
                  _buildNavItem(7, Icons.keyboard_alt_outlined, state.tr('shortcuts'), accent),
                ],
              ),
            ),
          ),
          const Divider(color: AppTheme.borderColor, height: 1),
          const SizedBox(height: 6),
          _buildNavItem(8, Icons.settings_outlined, state.tr('settings'), accent),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color accent, {String? badge}) {
    final isSelected = widget.selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: _SidebarItemWidget(
        icon: icon,
        label: label,
        badge: badge,
        isSelected: isSelected,
        isExpanded: _isExpanded,
        accent: accent,
        onTap: () => widget.onDestinationSelected(index),
      ),
    );
  }
}

class _SidebarItemWidget extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final bool isSelected;
  final bool isExpanded;
  final Color accent;
  final VoidCallback onTap;

  const _SidebarItemWidget({
    required this.icon,
    required this.label,
    this.badge,
    required this.isSelected,
    required this.isExpanded,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_SidebarItemWidget> createState() => _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends State<_SidebarItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isSelected
        ? widget.accent.withOpacity(0.2)
        : (_isHovered ? Colors.white.withOpacity(0.06) : Colors.transparent);

    final border = widget.isSelected
        ? Border.all(color: widget.accent.withOpacity(0.7), width: 1.5)
        : null;

    final iconColor = widget.isSelected ? widget.accent : (_isHovered ? Colors.white : AppTheme.textSecondary);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: widget.isExpanded ? 12 : 6,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: border,
          ),
          child: Row(
            mainAxisAlignment: widget.isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 20, color: iconColor),
              if (widget.isExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                      color: widget.isSelected ? Colors.white : AppTheme.textPrimaryDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppTheme.yellowAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppTheme.yellowAccent, width: 0.5),
                    ),
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppTheme.yellowAccent),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
