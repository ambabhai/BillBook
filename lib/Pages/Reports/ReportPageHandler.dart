import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../Model/deal_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

mixin ReportHandler<T extends StatefulWidget> on State<T> {
  List<DealModel> allDeals = [];


  Future<void> generateFullReport() async {
    final pdf = pw.Document();

    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM yyyy – HH:mm').format(now);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          double totalProfit = 0;

          // Table data
          final data = allDeals.expand((deal) {
            return deal.items.map((item) {
              final total = item.qty * item.customerRate;
              final profit = (item.customerRate - item.supplierRate) * item.qty;
              totalProfit += profit;
              return [
                deal.customer,
                deal.supplier,
                item.product,
                item.brand,
                item.qty.toStringAsFixed(2),
                item.customerRate.toStringAsFixed(2),
                item.supplierRate.toStringAsFixed(2),
                total.toStringAsFixed(2),
                profit.toStringAsFixed(2),
                deal.paymentDone ? "Paid" : "Unpaid",
                deal.orderCompleted ? "Completed" : "Pending",
                DateFormat('dd MMM yyyy').format(deal.date),
              ];
            });
          }).toList();

          return [
            // Header
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Full Deals Report",
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text("Generated on: $formattedDate", style: pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
                pw.SizedBox(height: 12),
              ],
            ),

            // Table
            pw.Table.fromTextArray(
              headers: [
                "Customer",
                "Supplier",
                "Product",
                "Brand",
                "Qty",
                "Customer Rate",
                "Supplier Rate",
                "Total",
                "Profit",
                "Payment",
                "Order Status",
                "Date"
              ],
              data: data,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: pw.BoxDecoration(color: PdfColors.blue),
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: pw.TextStyle(fontSize: 10),
              cellPadding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              rowDecoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                ),
              ),
              oddRowDecoration: pw.BoxDecoration(color: PdfColors.grey100),
            ),

            pw.SizedBox(height: 12),

            // Summary
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Total Deals: ${allDeals.length}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Total Profit: ₹${totalProfit.toStringAsFixed(2)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
          ];
        },
      ),
    );

    // Preview & print/save PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

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


// Profit summary
  double calculateTotalProfit() {
    double total = 0;

    for (var deal in allDeals) {
      total += deal.totalProfit;
    }

    return total;
  }

  double calculateProfitSummary({required String period}) {
    final now = DateTime.now();
    double total = 0;

    for (var deal in allDeals) {
      bool include = false;

      if (period == 'week') {
        include = deal.date.isAfter(
          now.subtract(const Duration(days: 7)),
        );
      } else if (period == 'month') {
        include =
            deal.date.month == now.month &&
                deal.date.year == now.year;
      } else if (period == 'year') {
        include = deal.date.year == now.year;
      }

      if (include) {
        total += deal.totalProfit;
      }
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