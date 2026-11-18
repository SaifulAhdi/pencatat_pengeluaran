import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/helpers.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseTile({super.key, required this.expense, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Icon(categoryIcon(expense.category))),
        title: Text(expense.title),
        subtitle: Text('${expense.category} ${formatTanggal(expense.date)}'),
        trailing: Text(
          formatRupiah(expense.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
