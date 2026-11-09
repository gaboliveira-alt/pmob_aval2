import 'package:flutter/material.dart';

import '../../domain/models/item_situation.dart';

final class SituationBadge extends StatelessWidget {
  const SituationBadge({required this.situation, super.key});

  final ItemSituation situation;

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor) = switch (situation) {
      ItemSituation.lost => (Colors.red.shade100, Colors.red.shade900),
      ItemSituation.found => (Colors.green.shade100, Colors.green.shade900),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        situation.label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
