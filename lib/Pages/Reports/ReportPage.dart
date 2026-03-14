import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';
import 'package:intl/intl.dart';

import 'ReportPageHandler.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});
  static const routeName = "ReportPage";

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with ReportHandler {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text("Reports", style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFilters(),
            SizedBox(height: 12.h),
            Expanded(child: buildDealsTable()),
          ],
        ),
      ),
    );
  }

  Widget buildFilters() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        DropdownButton<String>(
          hint: const Text("Customer"),
          value: selectedCustomer,
          items: [null, ...customers].map((c) {
            return DropdownMenuItem<String>(
              value: c,
              child: Text(c ?? "All"),
            );
          }).toList(),
          onChanged: (v) {
            setState(() => selectedCustomer = v);
            applyFilters();
          },
        ),
        DropdownButton<String>(
          hint: const Text("Product"),
          value: selectedProduct,
          items: [null, ...products].map((p) {
            return DropdownMenuItem<String>(
              value: p,
              child: Text(p ?? "All"),
            );
          }).toList(),
          onChanged: (v) {
            setState(() => selectedProduct = v);
            applyFilters();
          },
        ),
        DropdownButton<String>(
          hint: const Text("Brand"),
          value: selectedBrand,
          items: [null, ...brands].map((b) {
            return DropdownMenuItem<String>(
              value: b,
              child: Text(b ?? "All"),
            );
          }).toList(),
          onChanged: (v) {
            setState(() => selectedBrand = v);
            applyFilters();
          },
        ),
        ElevatedButton(
            onPressed: () => pickFromDate(context),
            child: Text(fromDate == null ? "From Date" : DateFormat('dd/MM/yyyy').format(fromDate!))),
        ElevatedButton(
            onPressed: () => pickToDate(context),
            child: Text(toDate == null ? "To Date" : DateFormat('dd/MM/yyyy').format(toDate!))),
        IconButton(
          onPressed: clearFilters,
          icon: const Icon(Icons.clear, color: Colors.red),
        ),
      ],
    );
  }

  Widget buildDealsTable() {
    if (filteredDeals.isEmpty) {
      return const Center(child: Text("No deals found."));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) => AppTheme.primary.withOpacity(0.2)),
        columns: const [
          DataColumn(label: Text("Customer")),
          DataColumn(label: Text("Product")),
          DataColumn(label: Text("Brand")),
          DataColumn(label: Text("Qty")),
          DataColumn(label: Text("Rate")),
          DataColumn(label: Text("Payment Done")),
        ],
        rows: filteredDeals.map((deal) {
          return DataRow(
            cells: [
              DataCell(Text(deal.customer)),
              DataCell(Text(deal.product)),
              DataCell(Text(deal.brand)),
              DataCell(Text(deal.qty.toString())),
              DataCell(Text(deal.customerRate.toStringAsFixed(2))),
              DataCell(Text(deal.paymentDone ? "Yes" : "No")),
            ],
          );
        }).toList(),
      ),
    );
  }
}