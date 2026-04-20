import 'package:flutter/material.dart';
import 'package:jobconnect/presentation/utils/application_status_helper.dart';

/// Widget pur pour afficher un badge de statut
/// Responsabilité unique: Affichage du statut avec couleur
class StatusBadge extends StatelessWidget {
  final String status;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  const StatusBadge({
    Key? key,
    required this.status,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = ApplicationStatusHelper.getStatusColor(status);
    final statusLabel = ApplicationStatusHelper.getStatusLabel(status);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: ApplicationStatusHelper.getStatusBackgroundColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusLabel,
        style: textStyle ??
            TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
      ),
    );
  }
}
