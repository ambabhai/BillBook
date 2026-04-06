import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import '../../Constant/app_theme.dart';
import '../../Model/deal_model.dart';
import 'CreateDealHandler.dart';

class EditDealPage extends StatefulWidget {
  final DealModel deal; // pass the deal to edit
  const EditDealPage({super.key, required this.deal});
  static const routeName = "EditDealPage";

  @override
  State<EditDealPage> createState() => _EditDealPageState();
}

class _EditDealPageState extends State<EditDealPage> with CreateDealHandler {
  @override
  void initState() {
    super.initState();
    loadSavedData(); // load products, brands, customers, suppliers
    populateDealData(); // pre-fill the deal info
  }

  void populateDealData() {
    final deal = widget.deal;
    customerController.text = deal.customer;
    supplierController.text = deal.supplier;
    selectedDate = deal.date;
    orderCompleted = deal.orderCompleted;

    itemForms = deal.items.map((item) {
      final form = DealItemFormModel();
      form.selectedProduct = item.product;
      form.selectedBrand = item.brand;
      form.qtyController.text = item.qty.toString();
      form.customerRateController.text = item.customerRate.toString();
      form.supplierRateController.text = item.supplierRate.toString();
      form.paymentDone = deal.paymentDone;
      form.profit = (item.customerRate - item.supplierRate) * item.qty;
      return form;
    }).toList();

    setState(() {});
  }

  Future<void> updateDeal() async {
    String customer = customerController.text.trim();
    String supplier = supplierController.text.trim();

    if (customer.isEmpty || supplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter customer and supplier")),
      );
      return;
    }

    for (int i = 0; i < itemForms.length; i++) {
      final item = itemForms[i];
      if (item.selectedProduct == null ||
          item.selectedBrand == null ||
          item.qtyController.text.trim().isEmpty ||
          item.customerRateController.text.trim().isEmpty ||
          item.supplierRateController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please complete Item ${i + 1}")),
        );
        return;
      }
    }

    var dealsBox = await Hive.openBox<DealModel>('dealsBox');

    List<DealItemModel> updatedItems = [];
    for (var item in itemForms) {
      updatedItems.add(
        DealItemModel(
          product: item.selectedProduct ?? '',
          brand: item.selectedBrand ?? '',
          qty: double.tryParse(item.qtyController.text) ?? 0,
          customerRate: double.tryParse(item.customerRateController.text) ?? 0,
          supplierRate: double.tryParse(item.supplierRateController.text) ?? 0,
        ),
      );
    }

    // Update the existing deal
    widget.deal.customer = customer;
    widget.deal.supplier = supplier;
    widget.deal.date = selectedDate;
    widget.deal.orderCompleted = orderCompleted;
    widget.deal.items = updatedItems;
    widget.deal.paymentDone = itemForms.any((e) => e.paymentDone);

    await widget.deal.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Deal updated successfully")),
    );

    Navigator.pop(context, true); // return to previous page
  }

  @override
  Widget build(BuildContext context) {
    // We reuse the exact same UI from CreateDealPage
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text(
          "Edit Deal",
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppTheme.background,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: updateDeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: const Text(
                        "Update Deal",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: showShareOptions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: const Text(
                        "Share",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}