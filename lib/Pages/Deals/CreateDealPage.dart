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

  Widget buildPartyDetailsCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEC),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Party Details",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
          SizedBox(height: 16.h),

          buildAutoCompleteField(
            "Customer",
            customerController,
            customers,
            filterCustomer,
            filteredCustomers,
          ),
          SizedBox(height: 14.h),

          buildAutoCompleteField(
            "Supplier",
            supplierController,
            suppliers,
            filterSupplier,
            filteredSuppliers,
          ),
          SizedBox(height: 14.h),

          GestureDetector(
            onTap: () => pickDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 14.h,
                horizontal: 14.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      orderCompleted
                          ? Icons.check_circle
                          : Icons.pending_actions,
                      color: orderCompleted ? Colors.green : Colors.orange,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Order Completed",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: orderCompleted,
                  activeColor: AppTheme.primary,
                  onChanged: (value) {
                    setState(() {
                      orderCompleted = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItemsSection() {
    return Column(
      children: List.generate(itemForms.length, (index) {
        final item = itemForms[index];

        return Container(
          margin: EdgeInsets.only(bottom: 18.h),
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: AppTheme.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Item ${index + 1}",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: addNewItemCard,
                        icon: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      if (itemForms.length > 1)
                        IconButton(
                          onPressed: () => removeItemCard(index),
                          icon: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              buildProductDropdown(index),
              SizedBox(height: 14.h),

              buildBrandDropdown(index),
              SizedBox(height: 14.h),

              buildTextField(
                "Qty",
                item.qtyController,
                keyboard: TextInputType.number,
                onChanged: (_) => calculateItemProfit(index),
              ),
              SizedBox(height: 14.h),

              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      "Customer Rate",
                      item.customerRateController,
                      keyboard: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => calculateItemProfit(index),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: buildTextField(
                      "Supplier Rate",
                      item.supplierRateController,
                      keyboard: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => calculateItemProfit(index),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              buildProfitCard(index),
              SizedBox(height: 14.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Done?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: item.paymentDone,
                    activeColor: AppTheme.primary,
                    onChanged: (val) {
                      setState(() {
                        item.paymentDone = val;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 14.h),

              buildTextField(
                "Note",
                item.noteController,
                lines: 3,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildAutoCompleteField(
      String label,
      TextEditingController controller,
      List<String> list,
      Function(String) onChange,
      List<String> filtered,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        if (filtered.isNotEmpty)
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: filtered.map((e) {
              return InputChip(
                label: Text(
                  e,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                onPressed: () {
                  controller.text = e;
                  setState(() {
                    filtered.clear();
                  });
                },
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget buildTextField(
      String hint,
      TextEditingController controller, {
        TextInputType? keyboard,
        int lines = 1,
        Function(String)? onChanged,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: lines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F8F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildProfitCard(int index) {
    final item = itemForms[index];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            "Estimated Profit",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "₹ ${item.profit.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStickyButtons() {
    return Positioned(
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
                onPressed: saveDeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: const Text(
                  "Save Deal",
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
    );
  }
}