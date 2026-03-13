// import 'package:billbook/Constant/app_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class AppTextField extends StatelessWidget {
//
//   final String title;
//   final String hint;
//   final TextEditingController controller;
//
//   const AppTextField({
//     super.key,
//     required this.title,
//     required this.hint,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         SizedBox(height: 6.h),
//
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//
//             filled: true,
//             fillColor: Colors.white,
//
//             contentPadding:
//             EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
//
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.r),
//               borderSide: BorderSide(color: AppStyles.border),
//             ),
//           ),
//         ),
//
//         SizedBox(height: 16.h),
//       ],
//     );
//   }
// }