import 'package:billbook/Constant/app_theme.dart';
import 'package:billbook/Pages/More/MorePageHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MorePage extends StatefulWidget {
  static const routeName = 'MorePage';

  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> with MorePageHandler{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.h, top: 11.h, bottom: 11.h),
              child: Image.asset('assets/main.png',height: 25.2.h,
                color: AppTheme.card,
              ),
            ),
            SizedBox(width: 18.w),
            Text(
              'Bill Book',
              style: TextStyle(color: Colors.white, fontSize: 17.sp),
            ),
          ],
        ),

      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                      controller: scrollController,
                      // physics:
                      // textToImageState.status == GenerateImageStatus.loading
                      //     ? const NeverScrollableScrollPhysics()
                      //     : const AlwaysScrollableScrollPhysics(),
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      child:SafeArea(
                          child:Padding(padding: EdgeInsets.all(10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                              ],
                            ),)
                      )

                  ))
            ],
          )
        ],
      ),
    );
  }
}
