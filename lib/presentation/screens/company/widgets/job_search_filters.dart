import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobconnect/presentation/bloc/job_bloc.dart';
import 'package:jobconnect/presentation/theme/app_theme.dart';

/// Widget pour les filtres de recherche de jobs
/// Responsabilité unique: Affichage et gestion des filtres
class JobSearchFilters extends StatefulWidget {
  final VoidCallback onReload;

  const JobSearchFilters({Key? key, required this.onReload}) : super(key: key);

  @override
  State<JobSearchFilters> createState() => _JobSearchFiltersState();
}

class _JobSearchFiltersState extends State<JobSearchFilters> {
  String? _selectedCity;
  double _minPrice = 0;
  double _maxPrice = 10000;
  String? _selectedPricingType;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _cities = [
    'Tunis',
    'Sfax',
    'Sousse',
    'Bizerte',
    'Gabès',
    'Kairouan',
    'Kasserine',
    'Sidi Bouzid',
    'Tataouine',
    'Gafsa',
  ];

  final List<String> _pricingTypes = ['per hour', 'per day'];

  void _applyFilters() {
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      context.read<JobBloc>().add(FetchJobsByCityEvent(city: _selectedCity!));
    } else if (_selectedPricingType != null &&
        _selectedPricingType!.isNotEmpty) {
      context.read<JobBloc>().add(
        FetchJobsByPriceAndTypeEvent(
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          type: _selectedPricingType!,
        ),
      );
    } else {
      // Rechargement de toutes les offres
      widget.onReload();
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedCity = null;
      _minPrice = 0;
      _maxPrice = 10000;
      _selectedPricingType = null;
      _startDate = null;
      _endDate = null;
    });
    widget.onReload();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Filtres de recherche',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      backgroundColor: Colors.grey[50],
      collapsedBackgroundColor: Colors.grey[50],
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtre par ville
              Text(
                'Ville',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                hint: const Text('Sélectionnez une ville'),
                items: _cities
                    .map(
                      (city) =>
                          DropdownMenuItem(value: city, child: Text(city)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filtre par prix
              Text(
                'Gamme de prix',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 10000,
                    divisions: 50,
                    labels: RangeLabels(
                      '${_minPrice.toStringAsFixed(0)}€',
                      '${_maxPrice.toStringAsFixed(0)}€',
                    ),
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  Text(
                    '${_minPrice.toStringAsFixed(0)}€ - ${_maxPrice.toStringAsFixed(0)}€',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filtre par type de pricing
              Text(
                'Type de rémunération',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedPricingType,
                hint: const Text('Sélectionnez un type'),
                items: _pricingTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type == 'per hour' ? 'À l\'heure' : 'Par jour',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedPricingType = value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filtre par date
              Text(
                'Période',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectStartDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _startDate == null
                                    ? 'Date de début'
                                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: _selectEndDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _endDate == null
                                    ? 'Date de fin'
                                    : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.search),
                      label: const Text('Appliquer les filtres'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réinitialiser'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[500],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
