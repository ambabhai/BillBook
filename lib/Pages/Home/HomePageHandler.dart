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
      allDeals = box.values.toList().reversed.toList();

      recentDeals = allDeals.where((d) {
        return d.date.day == now.day &&
            d.date.month == now.month &&
            d.date.year == now.year;
      }).toList();

      todayDeals = recentDeals.length;

      double pending = 0;

      for (var deal in allDeals) {
        if (!deal.paymentDone) {
          pending += deal.totalCustomerAmount;
        }
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
    bool isPaid = deal.paymentDone;

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
            child: Icon(
              Icons.inventory,
              color: AppTheme.primary,
            ),
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
                SizedBox(height: 4.h),
                Text(
                  "${deal.items.length} Items",
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  deal.items
                      .map((e) => e.product)
                      .take(2)
                      .join(", "),
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${deal.totalCustomerAmount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                isPaid ? "Paid" : "Unpaid",
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.red,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }}