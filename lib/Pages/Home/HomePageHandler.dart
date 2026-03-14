import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

import '../../Constant/app_theme.dart';
import '../../Model/deal_model.dart';

mixin HomePageHandler<T extends StatefulWidget> on State<T> {
  List<DealModel> allDeals = [];

  int todayDeals = 0;
  String pendingAmount = "₹0";
  List<DealModel> recentDeals = [];

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    var box = await Hive.openBox<DealModel>('dealsBox');
    final now = DateTime.now();

    setState(() {
      allDeals = box.values
          .toList()
          .reversed
          .toList(); // latest first

      // Filter for today's deals
      recentDeals = allDeals.where((d) =>
      d.date.day == now.day &&
          d.date.month == now.month &&
          d.date.year == now.year
      ).toList();

      // Today's deals count
      todayDeals = recentDeals.length;

      // Pending Amount
      double pending = 0;
      for (var d in allDeals) {
        if (!d.paymentDone) pending += d.customerRate * d.qty;
      }
      pendingAmount = "₹${pending.toStringAsFixed(2)}";
    });
  }

  /// Greeting logic
  String greetingMessage() {
    final hour = DateTime
        .now()
        .hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  /// Summary Card
  Widget summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.textLight,
            ),
          )
        ],
      ),
    );
  }

  /// Quick action button
  Widget actionButton(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Icon(icon, color: AppTheme.primary),
          ),
          SizedBox(height: 6.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textDark,
            ),
          )
        ],
      ),
    );
  }

  /// Deal card
  Widget dealCard(DealModel deal) {
    bool isPaid = deal.paymentDone; // true or false

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Paid/Unpaid indicator
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPaid ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(width: 10.w),

          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.inventory, color: AppTheme.primary),
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deal.customer,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  deal.product,
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "₹${deal.customerRate}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          )
        ],
      ),
    );
  }
}