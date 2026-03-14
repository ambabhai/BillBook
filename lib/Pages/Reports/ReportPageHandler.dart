import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Model/deal_model.dart';

mixin ReportHandler<T extends StatefulWidget> on State<T> {
  List<DealModel> allDeals = [];

  @override
  void initState() {
    super.initState();
    loadDeals();
  }

  Future<void> loadDeals() async {
    var box = await Hive.openBox<DealModel>('dealsBox');
    setState(() {
      allDeals = box.values.toList();
    });
  }

  // Today's deals
  List<DealModel> todaysDeals() {
    final today = DateTime.now();
    return allDeals.where((d) =>
    d.date.day == today.day &&
        d.date.month == today.month &&
        d.date.year == today.year
    ).toList();
  }

  // Revenue
  double calculateTotalRevenue() {
    double total = 0;
    for (var d in allDeals) {
      total += d.customerRate * d.qty;
    }
    return total;
  }

  // Profit summary
  double calculateTotalProfit() {
    double total = 0;
    for (var d in allDeals) {
      total += (d.customerRate - d.supplierRate) * d.qty;
    }
    return total;
  }

  double calculateProfitSummary({required String period}) {
    final now = DateTime.now();
    double total = 0;
    for (var d in allDeals) {
      bool include = false;
      if (period == 'week') {
        include = d.date.isAfter(now.subtract(const Duration(days: 7)));
      } else if (period == 'month') {
        include = d.date.month == now.month && d.date.year == now.year;
      } else if (period == 'year') {
        include = d.date.year == now.year;
      }
      if (include) total += (d.customerRate - d.supplierRate) * d.qty;
    }
    return total;
  }

  int paidDealsCount() => allDeals.where((d) => d.paymentDone).length;
  int pendingDealsCount() => allDeals.where((d) => !d.paymentDone).length;

  Map<String, int> calculateCustomerSummary() {
    Map<String, int> map = {};
    for (var d in allDeals) {
      map[d.customer] = (map[d.customer] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> calculateSupplierSummary() {
    Map<String, int> map = {};
    for (var d in allDeals) {
      map[d.supplier] = (map[d.supplier] ?? 0) + 1;
    }
    return map;
  }
}