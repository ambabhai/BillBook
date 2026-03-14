import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Model/deal_model.dart';

mixin ReportHandler<T extends StatefulWidget> on State<T> {
  List<DealModel> allDeals = [];
  List<DealModel> filteredDeals = [];

  // Filter options
  String? selectedCustomer;
  String? selectedProduct;
  String? selectedBrand;
  DateTime? fromDate;
  DateTime? toDate;

  // For dropdown lists
  List<String> customers = [];
  List<String> products = [];
  List<String> brands = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReportData();
  }

  Future<void> loadReportData() async {
    setState(() {
      isLoading = true;
    });

    var box = await Hive.openBox<DealModel>('dealsBox');
    allDeals = box.values.toList().cast<DealModel>();

    // Fill filter dropdowns
    customers = allDeals.map((e) => e.customer).toSet().toList();
    products = allDeals.map((e) => e.product).toSet().toList();
    brands = allDeals.map((e) => e.brand).toSet().toList();

    filteredDeals = List.from(allDeals);

    setState(() {
      isLoading = false;
    });
  }

  void applyFilters() {
    filteredDeals = allDeals.where((deal) {
      bool matchesCustomer = selectedCustomer == null || deal.customer == selectedCustomer;
      bool matchesProduct = selectedProduct == null || deal.product == selectedProduct;
      bool matchesBrand = selectedBrand == null || deal.brand == selectedBrand;
      bool matchesFromDate = fromDate == null || deal.date.isAfter(fromDate!.subtract(const Duration(days: 1)));
      bool matchesToDate = toDate == null || deal.date.isBefore(toDate!.add(const Duration(days: 1)));

      return matchesCustomer && matchesProduct && matchesBrand && matchesFromDate && matchesToDate;
    }).toList();

    setState(() {});
  }

  Future<void> pickFromDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => fromDate = picked);
      applyFilters();
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => toDate = picked);
      applyFilters();
    }
  }

  void clearFilters() {
    selectedCustomer = null;
    selectedProduct = null;
    selectedBrand = null;
    fromDate = null;
    toDate = null;
    filteredDeals = List.from(allDeals);
    setState(() {});
  }
}