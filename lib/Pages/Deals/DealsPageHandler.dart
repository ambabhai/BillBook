import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../Model/deal_model.dart';

mixin DealsPageHandler<T extends StatefulWidget> on State<T> {
  List<DealModel> deals = [];
  List<DealModel> filteredDeals = [];

  // Filter Controllers
  TextEditingController searchController = TextEditingController();

  String? filterCustomer;
  String? filterSupplier;
  String? filterProduct;
  String? filterBrand;
  String? filterPayment; // Paid / Unpaid
  DateTime? filterStartDate;
  DateTime? filterEndDate;
  String? filterOrderStatus;

  List<String> customers = [];
  List<String> suppliers = [];
  List<String> products = [];
  List<String> brands = [];

  @override
  void initState() {
    super.initState();
    loadDeals();
  }

  Future<void> loadDeals() async {
    var box = await Hive.openBox<DealModel>('dealsBox');
    deals = box.values.toList();

    // Load unique names for filter dropdowns
    customers = deals.map((e) => e.customer).toSet().toList();
    suppliers = deals.map((e) => e.supplier).toSet().toList();
    products = deals
        .expand((deal)=> deal.items)
        .map((item)=> item.product)
        .where((e)=> e.isNotEmpty)
    .toSet().toList();
    brands = deals
        .expand((deal)=> deal.items)
        .map((item)=> item.brand)
        .where((e)=> e.isNotEmpty)
        .toSet().toList();

    applyFilters();
  }

  void applyFilters() {
    filteredDeals = deals.where((deal) {
      bool matchesSearch = searchController.text.isEmpty ||
          deal.customer.toLowerCase().contains(searchController.text.toLowerCase()) ||
          deal.supplier.toLowerCase().contains(searchController.text.toLowerCase()) ||
          deal.items.any((item)=> item.product.toLowerCase().contains(searchController.text.toLowerCase())) ||
          deal.items.any((item)=> item.brand.toLowerCase().contains(searchController.text.toLowerCase())) ;

      bool matchesCustomer =
          filterCustomer == null || deal.customer == filterCustomer;

      bool matchesSupplier =
          filterSupplier == null || deal.supplier == filterSupplier;

      bool matchesProduct = filterProduct == null ||
          deal.items.any((item) => item.product == filterProduct);

      bool matchesBrand = filterBrand == null ||
          deal.items.any((item) => item.brand == filterBrand);

      bool matchesPayment = filterPayment == null ||
          (filterPayment == "Paid" && deal.paymentDone) ||
          (filterPayment == "Unpaid" && !deal.paymentDone);

      bool matchesOrder = filterOrderStatus == null ||
          (filterOrderStatus == "Completed" && deal.orderCompleted) ||
          (filterOrderStatus == "Pending" && !deal.orderCompleted);

      bool matchesDate = true;

      if (filterStartDate != null) {
        matchesDate = deal.date.isAfter(
          filterStartDate!.subtract(const Duration(days: 1)),
        );
      }

      if (matchesDate && filterEndDate != null) {
        matchesDate = deal.date.isBefore(
          filterEndDate!.add(const Duration(days: 1)),
        );
      }

      return matchesSearch &&
          matchesCustomer &&
          matchesSupplier &&
          matchesProduct &&
          matchesBrand &&
          matchesPayment &&
          matchesOrder &&
          matchesDate;
    }).toList();

    setState(() {});
  }

  void clearFilters() {
    filterCustomer = null;
    filterSupplier = null;
    filterProduct = null;
    filterBrand = null;
    filterPayment = null;
    filterOrderStatus = null;
    filterStartDate = null;
    filterEndDate = null;
    searchController.clear();
    applyFilters();
  }
  void deleteDeal(DealModel deal) async {
    var box = await Hive.openBox<DealModel>('dealsBox');
    await box.delete(deal.key);
    loadDeals();
  }

  /// Confirm before deleting a deal
  void deleteDealConfirmation(DealModel deal) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Deal"),
        content: Text("Are you sure you want to delete the deal of ${deal.customer}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteDeal(deal);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}