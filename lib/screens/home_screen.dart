import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import 'expense_form_screen.dart';

import '../utils/helpers.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  String _filter = 'Semua';
  List<Expense> get _filtered => _filter == 'Semua'
      ? _expenses
      : _expenses.where((e) => e.category == _filter).toList();
  int get _totalToday {
    final now = DateTime.now();
    return _expenses
        .where(
          (e) =>
              e.date.year == now.year &&
              e.date.month == now.month &&
              e.date.day == now.day,
        )
        .fold<int>(0, (sum, e) => sum + e.amount);
  }

  int get _totalMonth {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold<int>(0, (sum, e) => sum + e.amount);
  }

  Future<void> _loadExpenses() async {
    final data = await DbHelper.instance.getAll();
    if (!mounted) return;
    setState(() {
      _expenses = data;
      _loading = false;
    });
  }

  Future<void> _openForm({Expense? expense}) async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (_) => ExpenseFormScreen(expense: expense)),
    );
    if (result == null) return;
    if (result.id == null) {
      await DbHelper.instance.insert(result);
    } else {
      await DbHelper.instance.update(result);
    }
    _loadExpenses();
  }

  Future<bool> _confirmDelete(Expense e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus pengeluaran?'),
        content: Text('${e.title} akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _delete(Expense e) async {
    setState(() => _expenses.removeWhere((x) => x.id == e.id));
    await DbHelper.instance.delete(e.id!);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pengeluaran dihapus')));
  }

  Widget _buildItem(Expense e) {
    return Dismissible(
      key: ValueKey(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(e),
      onDismissed: (_) => _delete(e),
      child: ExpenseTile(
        expense: e,
        onTap: () => _openForm(expense: e),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _filtered;
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Pengeluaran')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SummaryCard(totalToday: _totalToday, totalMonth: _totalMonth),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: ['Semua', ...kCategories].map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: _filter == c,
                          onSelected: (_) => setState(() => _filter = c),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: data.isEmpty
                      ? const Center(child: Text('Tidak ada data.'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: data.length,
                          itemBuilder: (context, index) =>
                              _buildItem(data[index]),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
