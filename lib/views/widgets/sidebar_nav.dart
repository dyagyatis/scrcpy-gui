import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SidebarNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SidebarNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: const BoxDecoration(
        color: AppTheme.bgSidebar,
        border: Border(right: BorderSide(color: AppTheme.borderColor, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Top Mobile Logo Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.purpleAccent.withOpacity(0.5), width: 1.5),
            ),
            child: const Icon(
              Icons.smartphone_rounded,
              color: AppTheme.purpleAccent,
              size: 22,
            ),
          ),
          const SizedBox(height: 16),
          // Nav items
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.favorite_border_rounded, 'Favorites'),
          _buildNavItem(2, Icons.grid_view_rounded, 'App Drawer', badge: 'BETA'),
          _buildNavItem(3, Icons.code_rounded, 'Scripts'),
          _buildNavItem(4, Icons.folder_open_rounded, 'Resources'),
          _buildNavItem(5, Icons.keyboard_alt_outlined, 'Shortcuts'),
          const Spacer(),
          _buildNavItem(6, Icons.settings_outlined, 'Settings'),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {String? badge}) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: InkWell(
        onTap: () => onDestinationSelected(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.purpleActive.withOpacity(0.4) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: AppTheme.purpleAccent.withOpacity(0.6), width: 1)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppTheme.purpleAccent : AppTheme.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (badge != null) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppTheme.yellowAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.yellowAccent, width: 0.5),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.yellowAccent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
