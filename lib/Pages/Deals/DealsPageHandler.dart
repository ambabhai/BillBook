import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../Model/deal_model.dart';
import '../../Constant/app_theme.dart';

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
    products = deals.map((e) => e.product).toSet().toList();
    brands = deals.map((e) => e.brand).toSet().toList();

    applyFilters();
  }

  void applyFilters() {
    filteredDeals = deals.where((deal) {
      bool matchesSearch = searchController.text.isEmpty ||
          deal.customer.toLowerCase().contains(searchController.text.toLowerCase()) ||
          deal.supplier.toLowerCase().contains(searchController.text.toLowerCase()) ||
          deal.product.toLowerCase().contains(searchController.text.toLowerCase()) ||
          deal.brand.toLowerCase().contains(searchController.text.toLowerCase());

      bool matchesCustomer = filterCustomer == null || deal.customer == filterCustomer;
      bool matchesSupplier = filterSupplier == null || deal.supplier == filterSupplier;
      bool matchesProduct = filterProduct == null || deal.product == filterProduct;
      bool matchesBrand = filterBrand == null || deal.brand == filterBrand;
      bool matchesPayment = filterPayment == null ||
          (filterPayment == "Paid" && deal.paymentDone) ||
          (filterPayment == "Unpaid" && !deal.paymentDone);

      bool matchesDate = true;
      if (filterStartDate != null) matchesDate = deal.date.isAfter(filterStartDate!.subtract(const Duration(days: 1)));
      if (matchesDate && filterEndDate != null) matchesDate = deal.date.isBefore(filterEndDate!.add(const Duration(days: 1)));

      return matchesSearch && matchesCustomer && matchesSupplier && matchesProduct && matchesBrand && matchesPayment && matchesDate;
    }).toList();

    setState(() {});
  }

  void clearFilters() {
    filterCustomer = null;
    filterSupplier = null;
    filterProduct = null;
    filterBrand = null;
    filterPayment = null;
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

  // Edit Deal Dialog with Date and Payment toggle
  void editDealDialog(DealModel deal) async {
    TextEditingController customerController = TextEditingController(text: deal.customer);
    TextEditingController supplierController = TextEditingController(text: deal.supplier);
    TextEditingController productController = TextEditingController(text: deal.product);
    TextEditingController brandController = TextEditingController(text: deal.brand);
    TextEditingController qtyController = TextEditingController(text: deal.qty.toString());
    TextEditingController custRateController = TextEditingController(text: deal.customerRate.toString());
    TextEditingController suppRateController = TextEditingController(text: deal.supplierRate.toString());

    DateTime selectedDate = deal.date;
    bool paymentDone = deal.paymentDone;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Edit Deal"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: customerController, decoration: const InputDecoration(labelText: "Customer")),
                TextField(controller: supplierController, decoration: const InputDecoration(labelText: "Supplier")),
                TextField(controller: productController, decoration: const InputDecoration(labelText: "Product")),
                TextField(controller: brandController, decoration: const InputDecoration(labelText: "Brand")),
                TextField(controller: qtyController, decoration: const InputDecoration(labelText: "Qty"), keyboardType: TextInputType.number),
                TextField(controller: custRateController, decoration: const InputDecoration(labelText: "Customer Rate"), keyboardType: TextInputType.number),
                TextField(controller: suppRateController, decoration: const InputDecoration(labelText: "Purchase Rate"), keyboardType: TextInputType.number),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setDialogState(() => selectedDate = picked);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Payment Done"),
                    Switch(
                      value: paymentDone,
                      onChanged: (val) => setDialogState(() => paymentDone = val),
                      activeColor: AppTheme.primary,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    deal.customer = customerController.text;
                    deal.supplier = supplierController.text;
                    deal.product = productController.text;
                    deal.brand = brandController.text;
                    deal.qty = double.tryParse(qtyController.text) ?? 0;
                    deal.customerRate = double.tryParse(custRateController.text) ?? 0;
                    deal.supplierRate = double.tryParse(suppRateController.text) ?? 0;
                    deal.paymentDone = paymentDone;
                    deal.date = selectedDate;
                    await deal.save();
                    loadDeals();
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Print individual deal like bill PDF
  Future<void> printDealPDF(DealModel deal) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                    child: pw.Text("BILL",
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 12),
                pw.Text("Customer: ${deal.customer}"),
                pw.Text("Supplier: ${deal.supplier}"),
                pw.Text("Date: ${DateFormat('dd/MM/yyyy').format(deal.date)}"),
                pw.SizedBox(height: 12),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFCCCCCC)),
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Product")),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Brand")),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Qty")),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Cust Rate")),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(deal.product)),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(deal.brand)),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(deal.qty.toString())),
                        pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(deal.customerRate.toString())),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Text("Payment Done: ${deal.paymentDone ? "Yes" : "No"}"),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'bill_${deal.customer}_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  /// Print all deals as table PDF with design
  Future<void> printDealsPDF() async {
    if (filteredDeals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No deals to print")));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          double totalCustomer = 0;
          double totalPurchase = 0;

          return [
            pw.Center(
              child: pw.Text(
                'Deals Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headers: ['No', 'Product', 'Brand', 'Qty', 'Cust Rate', 'Purchase Rate', 'Total Cust', 'Total Purch'],
              data: List.generate(filteredDeals.length, (index) {
                final d = filteredDeals[index];
                double totalCust = d.customerRate * d.qty;
                double totalPurch = d.supplierRate * d.qty;
                totalCustomer += totalCust;
                totalPurchase += totalPurch;

                return [
                  (index + 1).toString(),
                  d.product,
                  d.brand,
                  d.qty.toString(),
                  "${d.customerRate.toStringAsFixed(2)}",
                  "${d.supplierRate.toStringAsFixed(2)}",
                  "${totalCust.toStringAsFixed(2)}",
                  "${totalPurch.toStringAsFixed(2)}",
                ];
              }),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFEEEEEE)),
              rowDecoration: pw.BoxDecoration(
                  border: const pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5),
                  )),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(4),
              oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            ),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text('Total Customer: ${totalCustomer.toStringAsFixed(2)}    ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Total Purchase: ${totalPurchase.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            )
          ];
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'Deals_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
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