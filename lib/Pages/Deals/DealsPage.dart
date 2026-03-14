import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';
import 'DealsPageHandler.dart';
import '../../Model/deal_model.dart';
import 'package:intl/intl.dart';

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
        title: const Text("Deals", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:Padding(padding: EdgeInsets.symmetric(horizontal: 10.w),child:Row(
              children: [
                buildDropdownFilter("Customer", customers, filterCustomer, (val) => setState(() => filterCustomer = val)),
                buildDropdownFilter("Supplier", suppliers, filterSupplier, (val) => setState(() => filterSupplier = val)),
                buildDropdownFilter("Product", products, filterProduct, (val) => setState(() => filterProduct = val)),
                buildDropdownFilter("Brand", brands, filterBrand, (val) => setState(() => filterBrand = val)),
                buildDropdownFilter("Payment", ["Paid", "Unpaid"], filterPayment, (val) => setState(() => filterPayment = val)),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: pickDateRange,
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearFilters,
                ),
              ],
            ),)),
          SizedBox(height: 10.h),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: filteredDeals.length,
              itemBuilder: (_, index) {
                // Reverse the list by accessing from the end
                DealModel deal = filteredDeals[filteredDeals.length - 1 - index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: deal.paymentDone ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(4, 4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: const Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: deal.paymentDone ? Colors.green : Colors.red,
                      child: Icon(deal.paymentDone ? Icons.check : Icons.close, color: Colors.white),
                    ),
                    title: Text(
                      "${deal.customer} - ${deal.supplier}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${deal.product} | ${deal.brand} | Qty:${deal.qty} | ₹${deal.customerRate} | ${DateFormat('dd/MM/yyyy').format(deal.date)}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.print, color: AppTheme.primary),
                      onPressed: () => printDealPDF(deal),
                    ),
                    onTap: () => editDealDialog(deal),
                    onLongPress: () => deleteDealConfirmation(deal),
                    tileColor: Colors.transparent,
                  ),
                );
              },
            ),
          ),        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: printDealsPDF,
        label: const Text("Print Deals PDF"),
        icon: const Icon(Icons.print),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget buildDropdownFilter(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: DropdownButton<String>(
        value: selectedValue,
        hint: Text(label),
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) {
          onChanged(v);
          applyFilters();
        },
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
  }
}