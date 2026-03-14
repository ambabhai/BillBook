import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';
import 'DealsPageHandler.dart';
import '../../Pages/Deals/CreateDealPage.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});
  static const routeName = "DealsPage";

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> with DealsPageHandler {
  @override
  void initState() {
    super.initState();
    loadDeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text("Deals", style: TextStyle(color: Colors.white)),
      ),
      body: deals.isEmpty
          ? Center(child: Text("No deals yet", style: TextStyle(fontSize: 16.sp)))
          : ListView.builder(
        padding: EdgeInsets.all(14.w),
        itemCount: deals.length,
        itemBuilder: (ctx, index) {
          final deal = deals[index];
          return buildDealCard(deal, index);
        },
      ),
    );
  }

  Widget buildDealCard(deal, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: customer + supplier + delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${deal.customer} → ${deal.supplier}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              IconButton(
                  onPressed: () => confirmDelete(index),
                  icon: const Icon(Icons.delete, color: Colors.red))
            ],
          ),
          SizedBox(height: 6.h),
          Text("Date: ${deal.date.day}/${deal.date.month}/${deal.date.year}"),
          SizedBox(height: 8.h),
          Divider(),
          SizedBox(height: 6.h),
          // Product / Brand / Qty / Rates
          Row(
            children: [
              Expanded(child: Text("Product: ${deal.product}")),
              Expanded(child: Text("Brand: ${deal.brand}")),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(child: Text("Qty: ${deal.qty}")),
              Expanded(child: Text("Cust Rate: ₹${deal.customerRate}")),
              Expanded(child: Text("Supp Rate: ₹${deal.supplierRate}")),
            ],
          ),
          SizedBox(height: 6.h),
          Text("Profit: ₹${(deal.customerRate - deal.supplierRate) * deal.qty}"),
          Text("Payment Done: ${deal.paymentDone ? "Yes" : "No"}"),
          if(deal.note.isNotEmpty) Text("Note: ${deal.note}"),
        ],
      ),
    );
  }

  void confirmDelete(int index){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Do you want to delete this deal?"),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(ctx), child: const Text("Cancel")),
              TextButton(onPressed: (){
                Navigator.pop(ctx);
                deleteDeal(index);
              }, child: const Text("Delete", style: TextStyle(color: Colors.red))),
            ],
          );
        }
    );
  }
}