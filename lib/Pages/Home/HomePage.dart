import 'package:billbook/Pages/Deals/CreateDealPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';
import 'HomePageHandler.dart';

class HomePage extends StatefulWidget {
  static const routeName = "HomePage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomePageHandler {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              SizedBox(height: 24.h),
              buildSummaryCards(),
              SizedBox(height: 26.h),
              buildQuickActions(),
              SizedBox(height: 26.h),
              buildRecentDeals(),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greetingMessage(),
              style: TextStyle(
                fontSize: 15.sp,
                color: AppTheme.textLight,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Bill Book",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Icon(
            Icons.notifications_none,
            color: AppTheme.primary,
          ),
        )
      ],
    );
  }

  /// SUMMARY
  Widget buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: summaryCard(
            "Today's Deals",
            todayDeals.toString(),
            Icons.receipt,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: summaryCard(
            "Pending",
            pendingAmount,
            Icons.warning_amber,
          ),
        ),
      ],
    );
  }

  /// QUICK ACTIONS
  Widget buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            actionButton(Icons.add, "New Deal", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateDealPage(),
                ),
              ).then((_) => loadHomeData());
            }),
          ],
        )
      ],
    );
  }

  /// RECENT DEALS
  Widget buildRecentDeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Deals",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        SizedBox(height: 14.h),
        ...recentDeals.map((deal) => dealCard(deal)).toList(),
      ],
    );
  }
}