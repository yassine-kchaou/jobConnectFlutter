import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

/// Widget pour le filtre des candidatures
/// Responsabilité unique: UI et logique du filtre
class ApplicationFilterBar extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ApplicationFilterBar({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  // Liste des filtres disponibles
  static const List<Map<String, String>> filters = [
    {'value': 'all', 'label': 'Toutes'},
    {'value': 'pending', 'label': 'En attente'},
    {'value': 'accepted', 'label': 'Acceptées'},
    {'value': 'rejected', 'label': 'Rejetées'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            return _buildFilterChip(
              value: filter['value']!,
              label: filter['label']!,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String value,
    required String label,
  }) {
    final isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (selected) {
          onFilterChanged(value);
        },
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryBlue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }
}
