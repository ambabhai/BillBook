import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../Constant/app_theme.dart';
import 'CreateDealHandler.dart';

class CreateDealPage extends StatefulWidget {

  const CreateDealPage({super.key});
  static const routeName = "CreateDealPage";

  @override
  State<CreateDealPage> createState() => _CreateDealPageState();
}

class _CreateDealPageState extends State<CreateDealPage>
    with CreateDealHandler {

  @override
  void initState(){
    super.initState();
    loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text(
          "New Deal",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 18.w,
              right: 18.w,
              top: 18.h,
              bottom: 120.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPartyDetailsCard(),
                SizedBox(height: 18.h),
                buildItemsSection(),
              ],
            ),
          ),
          buildStickyButtons(),
        ],
      ),
    );
  }

}