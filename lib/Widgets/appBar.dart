// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
//
//   final String title;
//
//   const CommonAppBar({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return AppBar(
//       backgroundColor: AppStyles.primary,
//       elevation: 0,
//       automaticallyImplyLeading: false,
//       scrolledUnderElevation: 0,
//
//       titleSpacing: 0,
//
//       title: Row(
//         children: [
//
//           Padding(
//             padding: EdgeInsets.only(left: 8.w),
//             child: Image.asset(
//               'assets/main.png',
//               height: 25.h,
//               color: AppStyles.white,
//             ),
//           ),
//
//           SizedBox(width: 12.w),
//
//           Text(
//             title,
//             style: TextStyle(
//               color: AppStyles.white,
//               fontSize: 17.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }