import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../Constant/app_theme.dart';
import '../../Model/deal_model.dart';
import 'CreateDealPage.dart';
import 'DealsPageHandler.dart';

class DealsPage extends StatefulWidget {
  const DealsPage({super.key});
  static const routeName = "DealsPage";

  @override
  State<DealsPage> createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> with DealsPageHandler {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text(
          "Deals",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: TextField(
              controller: searchController,
              onChanged: (value) => applyFilters(),
              decoration: InputDecoration(
                hintText: "Search customer, supplier, product...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  buildDropdownFilter(
                    "Customer",
                    customers,
                    filterCustomer,
                        (val) => setState(() => filterCustomer = val),
                  ),
                  buildDropdownFilter(
                    "Supplier",
                    suppliers,
                    filterSupplier,
                        (val) => setState(() => filterSupplier = val),
                  ),
                  buildDropdownFilter(
                    "Product",
                    products,
                    filterProduct,
                        (val) => setState(() => filterProduct = val),
                  ),
                  buildDropdownFilter(
                    "Brand",
                    brands,
                    filterBrand,
                        (val) => setState(() => filterBrand = val),
                  ),
                  buildDropdownFilter(
                    "Payment",
                    ["Paid", "Unpaid"],
                    filterPayment,
                        (val) => setState(() => filterPayment = val),
                  ),
                  buildDropdownFilter(
                    "Order",
                    ["Completed", "Pending"],
                    filterOrderStatus,
                        (val) => setState(() => filterOrderStatus = val),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: pickDateRange,
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: clearFilters,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: filteredDeals.isEmpty
                ? const Center(
              child: Text("No deals found"),
            )
                : ListView.builder(
              itemCount: filteredDeals.length,
              itemBuilder: (_, index) {
                final deal =
                filteredDeals[filteredDeals.length - 1 - index];

                return GestureDetector(
                  onTap: () {

                  },
                  onLongPress: () => deleteDealConfirmation(deal),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: deal.paymentDone
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: deal.paymentDone
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Icon(
                                deal.paymentDone
                                    ? Icons.check
                                    : Icons.pending,
                                color: deal.paymentDone
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    deal.customer,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    deal.supplier,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: deal.orderCompleted
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                                borderRadius:
                                BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                deal.orderCompleted
                                    ? "Completed"
                                    : "Pending",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: deal.orderCompleted
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.h),

                        Divider(
                          thickness: 0.45,
                          // height: 0.002.h,
                          color: AppTheme.primary,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: buildInfoBox(
                                "Product",
                                deal.items.isNotEmpty ? deal.items.first.product : " - ",
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Expanded(
                            //   child: buildInfoBox(
                            //     "Brand",
                            //     deal.items.isNotEmpty ? deal.items.first.brand : " - ",),
                            // ),


                            Expanded(
                              child: buildInfoBox(
                                "Qty",
                                deal.items.isNotEmpty ? deal.items.first.qty.toString() : " 0 ",
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: buildInfoBox(
                                "Total",
                                "₹${deal.totalCustomerAmount.toStringAsFixed(2)}",
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 8.h),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: buildInfoBox(
                        //         "Qty",
                        //         deal.items.isNotEmpty ? deal.items.first.qty.toString() : " 0 ",
                        //       ),
                        //     ),
                        //     SizedBox(width: 8.w),
                        //     Expanded(
                        //       child: buildInfoBox(
                        //         "Total",
                        //         "₹${deal.totalCustomerAmount.toStringAsFixed(2)}",
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd MMM yyyy')
                                  .format(deal.date),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: deal.paymentDone
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius:
                                BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                deal.paymentDone
                                    ? "Paid"
                                    : "Unpaid",
                                style: TextStyle(
                                  color: deal.paymentDone
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownFilter(
      String label,
      List<String> options,
      String? selectedValue,
      Function(String?) onChanged,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text(label),
        items: options
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
            .toList(),
        onChanged: (v) {
          onChanged(v);
          applyFilters();
        },
      ),
    );
  }

  Widget buildInfoBox(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        filterStartDate = picked.start;
        filterEndDate = picked.end;
        applyFilters();
      });
    }
  }}

