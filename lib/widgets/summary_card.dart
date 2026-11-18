import 'package:flutter/material.dart';

import '../utils/helpers.dart';

class SummaryCard extends StatelessWidget {
  final int totalToday;
  final int totalMonth;
  const SummaryCard({
    super.key,
    required this.totalToday,
    required this.totalMonth,
  });
  Widget _item(BuildContext context, String label, int value) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          formatRupiah(value),
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(context, 'Hari ini', totalToday),
            _item(context, 'Bulan ini', totalMonth),
          ],
        ),
      ),
    );
  }
}
