import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<String> kCategories = [
  'Makan',
  'Transport',
  'Belanja',
  'Tagihan',
  'Hiburan',
  'Lainnya',
];

IconData categoryIcon(String category) {
  switch (category) {
    case 'Makan':
      return Icons.restaurant;
    case 'Transport':
      return Icons.directions_bus;
    case 'Belanja':
      return Icons.shopping_bag;
    case 'Tagihan':
      return Icons.receipt_long;
    case 'Hiburan':
      return Icons.movie;
    default:
      return Icons.category;
  }
}

String formatRupiah(int value) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(value);
}

String formatTanggal(DateTime date) {
  return DateFormat('d MM yyyy', 'id_ID').format(date);
}
