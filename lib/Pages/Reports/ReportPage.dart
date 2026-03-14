import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';
import 'package:intl/intl.dart';

import 'ReportPageHandler.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});
  static const routeName = "ReportsPage";

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with ReportHandler {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text("Reports", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMetricCard("Total Deals", allDeals.length.toString()),
            SizedBox(height: 5.h),
            buildMetricCard("Today's Deals", todaysDeals().length.toString()),
            SizedBox(height: 5.h),
            buildMetricCard("Total Revenue", "₹${calculateTotalRevenue().toStringAsFixed(2)}"),
            SizedBox(height: 5.h),
            buildMetricCard("Total Profit", "₹${calculateTotalProfit().toStringAsFixed(2)}"),
            SizedBox(height: 5.h),
            buildMetricCard("Paid Deals", "${paidDealsCount()}"),
            SizedBox(height: 5.h),
            buildMetricCard("Pending Deals", "${pendingDealsCount()}"),
            SizedBox(height: 5.h),
            Row(
              children: [
                Expanded(child:             buildProfitSummaryCard(),
                )
              ],
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget buildMetricCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp,color: Colors.green[700])),
          ],
        ),
      ),
    );
  }

  Widget buildProfitSummaryCard() {
    double weekly = calculateProfitSummary(period: 'week');
    double monthly = calculateProfitSummary(period: 'month');
    double yearly = calculateProfitSummary(period: 'year');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Profit Summary", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text("Weekly: ₹${weekly.toStringAsFixed(2)}"),
            Text("Monthly: ₹${monthly.toStringAsFixed(2)}"),
            Text("Yearly: ₹${yearly.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}