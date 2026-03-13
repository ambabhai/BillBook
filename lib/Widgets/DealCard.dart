// import 'package:billbook/Constant/app_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DealCard extends StatelessWidget {
//
//   final VoidCallback onRemove;
//
//   const DealCard({super.key, required this.onRemove});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 18.h),
//
//       padding: EdgeInsets.all(14.w),
//
//       decoration: BoxDecoration(
//         color: AppStyles.white,
//         borderRadius: BorderRadius.circular(14.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//           )
//         ],
//       ),
//
//       child: Column(
//         children: [
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//
//               Text(
//                 "Deal",
//                 style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.w600),
//               ),
//
//               IconButton(
//                 icon: Icon(Icons.delete_outline),
//                 onPressed: onRemove,
//               )
//             ],
//           ),
//
//           SizedBox(height: 10.h),
//
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Customer",
//             ),
//           ),
//
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Supplier",
//             ),
//           ),
//
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Product",
//             ),
//           ),
//
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Brand",
//             ),
//           ),
//
//           TextField(
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: "Quantity",
//             ),
//           ),
//
//           TextField(
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             decoration: InputDecoration(
//               labelText: "Purchase Rate",
//             ),
//           ),
//
//           TextField(
//             keyboardType: TextInputType.numberWithOptions(decimal: true),
//             decoration: InputDecoration(
//               labelText: "Sale Rate",
//             ),
//           ),
//
//           TextField(
//             decoration: InputDecoration(
//               labelText: "Note",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }