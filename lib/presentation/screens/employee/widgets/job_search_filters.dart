import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

class JobSearchFilters {
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final String? pricingType;
  final DateTime? startDate;
  final DateTime? endDate;

  JobSearchFilters({
    this.city,
    this.minPrice,
    this.maxPrice,
    this.pricingType,
    this.startDate,
    this.endDate,
  });

  bool isEmpty() {
    return city == null &&
        minPrice == null &&
        maxPrice == null &&
        pricingType == null &&
        startDate == null &&
        endDate == null;
  }

  JobSearchFilters copyWith({
    String? city,
    double? minPrice,
    double? maxPrice,
    String? pricingType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return JobSearchFilters(
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      pricingType: pricingType ?? this.pricingType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

class JobSearchFiltersWidget extends StatefulWidget {
  final JobSearchFilters initialFilters;
  final ValueChanged<JobSearchFilters> onFiltersChanged;

  const JobSearchFiltersWidget({
    Key? key,
    required this.initialFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<JobSearchFiltersWidget> createState() => _JobSearchFiltersWidgetState();
}

class _JobSearchFiltersWidgetState extends State<JobSearchFiltersWidget> {
  late JobSearchFilters _filters;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _cityController.text = _filters.city ?? '';
    _minPriceController.text = _filters.minPrice?.toString() ?? '';
    _maxPriceController.text = _filters.maxPrice?.toString() ?? '';
  }

  @override
  void dispose() {
    _cityController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final double? minPrice = _minPriceController.text.isEmpty
        ? null
        : double.tryParse(_minPriceController.text);
    final double? maxPrice = _maxPriceController.text.isEmpty
        ? null
        : double.tryParse(_maxPriceController.text);

    _filters = JobSearchFilters(
      city: _cityController.text.isEmpty ? null : _cityController.text,
      minPrice: minPrice,
      maxPrice: maxPrice,
      pricingType: _filters.pricingType,
      startDate: _filters.startDate,
      endDate: _filters.endDate,
    );

    print(
        '✅ Applied filters: city=${_filters.city}, minPrice=${_filters.minPrice}, maxPrice=${_filters.maxPrice}, pricingType=${_filters.pricingType}');
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    _filters = JobSearchFilters();
    _cityController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtrer les offres',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ville
            Text(
              'Ville',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Entrez une ville',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Salaire (TND)
            Text(
              'Salaire (TND)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Min',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Max',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Type de rémunération
            Text(
              'Type de rémunération',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['hourly', 'daily', 'monthly'].map((type) {
                final labels = {
                  'hourly': 'Par heure',
                  'daily': 'Par jour',
                  'monthly': 'Par mois',
                };
                return FilterChip(
                  label: Text(labels[type] ?? type),
                  selected: _filters.pricingType == type,
                  onSelected: (selected) {
                    setState(() {
                      _filters = _filters.copyWith(
                        pricingType: selected ? type : null,
                      );
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    child: const Text('Réinitialiser'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                    ),
                    child: const Text('Appliquer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
