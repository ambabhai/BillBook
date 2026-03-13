import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Constant/app_theme.dart';
import 'CreateDealHandler.dart';
import 'package:intl/intl.dart';

class CreateDealPage extends StatefulWidget {
  const CreateDealPage({super.key});
  static const routeName = "CreateDealPage";

  @override
  State<CreateDealPage> createState() => _CreateDealPageState();
}

class _CreateDealPageState extends State<CreateDealPage> with CreateDealHandler {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        title: const Text("New Deal", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 18.w,right: 18.w,top: 18.h,bottom: 100.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDealCard(),
              ],
            ),
          ),
          buildStickyButtons(),
        ],
      ),
    );
  }

  Widget buildDealCard() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEC),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer autosuggest
          buildAutoCompleteField("Customer", customerController, customers, filterCustomer, filteredCustomers),
          SizedBox(height: 14.h),
          // Supplier autosuggest
          buildAutoCompleteField("Supplier", supplierController, suppliers, filterSupplier, filteredSuppliers),
          SizedBox(height: 14.h),
          // Date
          GestureDetector(
            onTap: ()=> pickDate(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                  const Icon(Icons.calendar_today)
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          // Product dropdown
          buildProductDropdown(),
          SizedBox(height: 14.h),
          // Brand dropdown
          buildBrandDropdown(),
          SizedBox(height: 14.h),
          // Qty row
          buildTextField("Qty", qtyController, keyboard: TextInputType.number, onChanged: (_) => calculateProfit()),
          SizedBox(height: 14.h),
          // Customer rate & Supplier rate row
          Row(
            children: [
              Expanded(child: buildTextField("Customer Rate", customerRateController, keyboard: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => calculateProfit())),
              SizedBox(width: 8.w),
              Expanded(child: buildTextField("Supplier Rate", supplierRateController, keyboard: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => calculateProfit())),
            ],
          ),
          SizedBox(height: 14.h),
          // Profit card
          buildProfitCard(),
          SizedBox(height: 14.h),
          // Payment toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Payment Done?"),
              Switch(
                value: paymentDone,
                onChanged: (val){
                  setState(() {
                    paymentDone = val;
                  });
                },
                activeColor: AppTheme.primary,
              )
            ],
          ),
          SizedBox(height: 14.h),
          // Note
          buildTextField("Note", noteController, lines: 3),
        ],
      ),
    );
  }

  Widget buildAutoCompleteField(String label, TextEditingController controller, List<String> list, Function(String) onChange, List<String> filtered){
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
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        ...filtered.map((e) => GestureDetector(
          onTap: (){
            controller.text = e;
            setState((){});
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 12.w),
            color: Colors.grey.shade200,
            child: Text(e),
          ),
        ))
      ],
    );
  }

  Widget buildTextField(String hint, TextEditingController controller, {TextInputType? keyboard, int lines = 1, Function(String)? onChanged}){
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: lines,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildProductDropdown(){
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedProduct,
            hint: const Text("Select Product"),
            items: [
              ...products.map((p)=> DropdownMenuItem(
                value: p,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p),
                    GestureDetector(
                      onTap: ()=> confirmRemove('product',p),
                      child: const Icon(Icons.cancel,color: Colors.red),
                    )
                  ],
                ),
              )),
            ],
            onChanged: (v){
              setState((){selectedProduct=v;});
            },
          ),
        ),
        IconButton(onPressed: addProductDialog, icon: const Icon(Icons.add))
      ],
    );
  }

  Widget buildBrandDropdown(){
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedBrand,
            hint: const Text("Select Brand"),
            items: [
              ...brands.map((b)=> DropdownMenuItem(
                value: b,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(b),
                    GestureDetector(
                      onTap: ()=> confirmRemove('brand',b),
                      child: const Icon(Icons.cancel,color: Colors.red),
                    )
                  ],
                ),
              )),
            ],
            onChanged: (v){
              setState((){selectedBrand=v;});
            },
          ),
        ),
        IconButton(onPressed: addBrandDialog, icon: const Icon(Icons.add))
      ],
    );
  }

  void confirmRemove(String type,String value){
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: Text("Do you want to remove this $type?"),
            actions: [
              TextButton(onPressed: ()=> Navigator.pop(context), child: const Text("Cancel")),
              TextButton(onPressed: (){
                Navigator.pop(context);
                if(type=='product'){
                  removeProduct(value);
                }else{
                  removeBrand(value);
                }
              }, child: const Text("Remove")),
            ],
          );
        }
    );
  }

  Widget buildProfitCard(){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          const Text("Estimated Profit"),
          SizedBox(height: 6.h),
          Text("₹ ${profit.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold,color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  Widget buildStickyButtons(){
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(14.w),
        color: AppTheme.background,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: saveDeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: const Text("Save Deal",style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: shareDealPDF,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: const Text("Share",style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}