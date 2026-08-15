import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'custom_card.dart';

class ApplicationsCard extends StatefulWidget {
  const ApplicationsCard({super.key});

  @override
  State<ApplicationsCard> createState() => _ApplicationsCardState();
}

class _ApplicationsCardState extends State<ApplicationsCard> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSectionCard(
      title: 'Applications',
      icon: Icons.grid_view_rounded,
      accentColor: AppTheme.yellowAccent,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search App...',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 16, color: AppTheme.purpleAccent),
                tooltip: 'Refresh Apps',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 16, color: AppTheme.purpleAccent),
                tooltip: 'Clear',
                onPressed: () => _searchController.clear(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
