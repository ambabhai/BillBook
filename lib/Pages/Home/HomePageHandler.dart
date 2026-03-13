import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';

mixin HomePageHandler<T extends StatefulWidget> on State<T> {

  /// Dummy Data (later you will load from Hive)

  List<Map<String,dynamic>> recentDeals = [

    {
      "name":"Rameshbhai",
      "product":"UltraTech Cement",
      "amount":"₹38,000"
    },

    {
      "name":"Mahesh",
      "product":"ACC Cement",
      "amount":"₹22,500"
    },

    {
      "name":"Rajesh",
      "product":"Ambuja Cement",
      "amount":"₹19,000"
    },

  ];

  int todayDeals = 5;

  String pendingAmount = "₹24k";

  /// Navigation placeholder
  void openNewDeal(){

    // Navigator.pushNamed(context, NewDealPage.routeName);

  }

  /// Greeting logic

  String greetingMessage(){

    final hour = DateTime.now().hour;

    if(hour < 12){
      return "Good Morning";
    }
    else if(hour < 17){
      return "Good Afternoon";
    }
    else{
      return "Good Evening";
    }

  }

  /// Summary Card

  Widget summaryCard(String title,String value,IconData icon){

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

          Icon(icon,color: AppTheme.primary),

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

  Widget actionButton(IconData icon,String text,VoidCallback onTap){

    return GestureDetector(
      onTap: onTap,
      child:Column(

        children: [

          Container(

            padding: EdgeInsets.all(14.w),

            decoration: BoxDecoration(

              color: AppTheme.card,

              borderRadius: BorderRadius.circular(16.r),

              boxShadow: AppTheme.cardShadow,

            ),

            child: Icon(icon,color: AppTheme.primary),

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

  Widget dealCard(Map<String,dynamic> deal){

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
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.inventory,color: AppTheme.primary),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  deal["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppTheme.textDark,
                  ),
                ),

                Text(
                  deal["product"],
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 12.sp,
                  ),
                ),

              ],
            ),
          ),

          Text(
            deal["amount"],
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