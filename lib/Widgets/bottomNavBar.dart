import 'package:billbook/Constant/app_theme.dart';
import 'package:billbook/Pages/Deals/DealsPage.dart';
import 'package:billbook/Pages/Home/HomePage.dart';
import 'package:billbook/Pages/More/MorePage.dart';
import 'package:billbook/Pages/Reports/ReportPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int currentIndex = 0;

  /// FIXED TYPE
  final List pages = [
    const HomePage(),
    const DealsPage(),
    const ReportPage(),
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppTheme.background,

      body: pages[currentIndex],

      bottomNavigationBar: buildNavBar(),
    );
  }

  Widget buildNavBar() {

    return Container(

      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 14.h,
      ),

      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),

      decoration: BoxDecoration(

        /// DARK PRIMARY VARIANT
        color: const Color(0xFF2A3A5B),

        borderRadius: BorderRadius.circular(22.r),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 20,
            offset: const Offset(0,10),
          ),

        ],
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [

          navItem(Icons.home_rounded,"Home",0),
          navItem(Icons.receipt_long_rounded,"Deals",1),
          navItem(Icons.bar_chart_rounded,"Reports",2),
          navItem(Icons.menu_rounded,"Menu",3),

        ],
      ),
    );
  }


  Widget navItem(IconData icon, String label, int index) {

    bool isActive = currentIndex == index;

    return GestureDetector(

      onTap: (){
        setState(() {
          currentIndex = index;
        });
      },

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 250),

        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 8.h,
        ),

        decoration: BoxDecoration(

          color: isActive
              ? Colors.white.withOpacity(.15)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(16.r),

        ),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : Colors.white.withOpacity(.7),
              size: 24.sp,
            ),

            SizedBox(height: 4.h),

            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Colors.white.withOpacity(.7),
              ),
            ),

          ],
        ),
      ),
    );
  }}