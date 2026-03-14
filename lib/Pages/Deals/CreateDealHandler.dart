import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../Model/deal_model.dart';

mixin CreateDealHandler<T extends StatefulWidget> on State<T> {
  // Controllers
  final TextEditingController customerController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController customerRateController = TextEditingController();
  final TextEditingController supplierRateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  // Lists
  List<String> products = [];
  List<String> brands = [];
  List<String> customers = [];
  List<String> suppliers = [];

  String? selectedProduct;
  String? selectedBrand;

  bool paymentDone = false;
  double profit = 0;

  // Live filter lists for autocomplete
  List<String> filteredCustomers = [];
  List<String> filteredSuppliers = [];

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  /// Load previously saved products, brands, customers, suppliers from Hive
  Future<void> loadSavedData() async {
    var productBox = await Hive.openBox<String>('productsBox');
    var brandBox = await Hive.openBox<String>('brandsBox');
    var customerBox = await Hive.openBox<String>('customersBox');
    var supplierBox = await Hive.openBox<String>('suppliersBox');

    setState(() {
      products = productBox.values.toList();
      brands = brandBox.values.toList();
      customers = customerBox.values.toList();
      suppliers = supplierBox.values.toList();
      filteredCustomers = List.from(customers);
      filteredSuppliers = List.from(suppliers);
    });
  }

  // Profit calculation
  void calculateProfit() {
    double qty = double.tryParse(qtyController.text) ?? 0;
    double custRate = double.tryParse(customerRateController.text) ?? 0;
    double suppRate = double.tryParse(supplierRateController.text) ?? 0;
    setState(() {
      profit = (custRate - suppRate) * qty;
    });
  }

  // Live filter for autocomplete
  void filterCustomer(String input){
    setState(() {
      filteredCustomers = customers
          .where((c) => c.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  void filterSupplier(String input){
    setState(() {
      filteredSuppliers = suppliers
          .where((s) => s.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  /// Save deal to Hive
  Future<void> saveDeal() async {
    String customer = customerController.text.trim();
    String supplier = supplierController.text.trim();
    double qty = double.tryParse(qtyController.text) ?? 0;
    double custRate = double.tryParse(customerRateController.text) ?? 0;
    double suppRate = double.tryParse(supplierRateController.text) ?? 0;
    String product = selectedProduct ?? '';
    String brand = selectedBrand ?? '';
    String note = noteController.text.trim();

    if(customer.isEmpty || supplier.isEmpty || product.isEmpty || brand.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields"))
      );
      return;
    }

    // Save strings to separate boxes
    var productBox = await Hive.openBox<String>('productsBox');
    var brandBox = await Hive.openBox<String>('brandsBox');
    var customerBox = await Hive.openBox<String>('customersBox');
    var supplierBox = await Hive.openBox<String>('suppliersBox');

    if(!products.contains(product)) {
      products.add(product);
      await productBox.put(product, product);
    }
    if(!brands.contains(brand)) {
      brands.add(brand);
      await brandBox.put(brand, brand);
    }
    if(!customers.contains(customer)) {
      customers.add(customer);
      await customerBox.put(customer, customer);
    }
    if(!suppliers.contains(supplier)) {
      suppliers.add(supplier);
      await supplierBox.put(supplier, supplier);
    }

    // Save deal
    var dealsBox = await Hive.openBox<DealModel>('dealsBox');
    await dealsBox.add(DealModel(
      customer: customer,
      supplier: supplier,
      product: product,
      brand: brand,
      qty: qty,
      customerRate: custRate,
      supplierRate: suppRate,
      paymentDone: paymentDone,
      note: note,
      date: selectedDate,
      profit: profit,
    ));

    // Reset fields
    customerController.clear();
    supplierController.clear();
    qtyController.clear();
    customerRateController.clear();
    supplierRateController.clear();
    noteController.clear();
    selectedProduct = null;
    selectedBrand = null;
    paymentDone = false;
    profit = 0;
    selectedDate = DateTime.now();

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deal saved successfully"))
    );
  }

  /// Add Product
  void addProductDialog() {
    TextEditingController newController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Product"),
        content: TextField(
          controller: newController,
          decoration: const InputDecoration(hintText: "Enter product name"),
        ),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(onPressed: () async {
            String value = newController.text.trim();
            if(value.isNotEmpty && !products.contains(value)){
              products.add(value);
              selectedProduct = value;
              var productBox = await Hive.openBox<String>('productsBox');
              await productBox.put(value, value); // Save in Hive
            }
            Navigator.pop(ctx);
            setState((){}); // Single tap add
          }, child: const Text("Add")),
        ],
      ),
    );
  }

  /// Add Brand
  void addBrandDialog() {
    TextEditingController newController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Brand"),
        content: TextField(
          controller: newController,
          decoration: const InputDecoration(hintText: "Enter brand name"),
        ),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(onPressed: () async {
            String value = newController.text.trim();
            if(value.isNotEmpty && !brands.contains(value)){
              brands.add(value);
              selectedBrand = value;
              var brandBox = await Hive.openBox<String>('brandsBox');
              await brandBox.put(value, value); // Save in Hive
            }
            Navigator.pop(ctx);
            setState((){}); // Single tap add
          }, child: const Text("Add")),
        ],
      ),
    );
  }

  /// Remove Product/Brand with confirmation
  void confirmRemove(String type, String name){
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: Text("Do you want to remove '$name'?"),
            actions: [
              TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text("Cancel")),
              TextButton(onPressed: () async {
                if(type=='product') await removeProduct(name);
                else if(type=='brand') await removeBrand(name);
                Navigator.pop(ctx);
              }, child: const Text("Remove", style: TextStyle(color: Colors.red))),
            ],
          );
        }
    );
  }

  Future<void> removeProduct(String name) async {
    products.remove(name);
    if(selectedProduct==name) selectedProduct=null;
    var productBox = await Hive.openBox<String>('productsBox');
    await productBox.delete(name);
    setState((){});
  }

  Future<void> removeBrand(String name) async {
    brands.remove(name);
    if(selectedBrand==name) selectedBrand=null;
    var brandBox = await Hive.openBox<String>('brandsBox');
    await brandBox.delete(name);
    setState((){});
  }

  /// Pick date
  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );
    if(picked != null){
      setState(()=>selectedDate = picked);
    }
  }

  /// Share deal as PDF
  Future<void> shareDealPDF() async {
    if(selectedProduct == null || selectedBrand == null || customerController.text.isEmpty ){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete the deal first"))
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text("BILL", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 12),
                pw.Text("Customer: ${customerController.text}"),
                pw.Text("Supplier: ${supplierController.text}"),
                pw.Text("Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                pw.SizedBox(height: 12),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(2),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFCCCCCC)),
                        children: [
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Product")),
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Brand")),
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Qty")),
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text("Cust Rate")),
                        ]
                    ),
                    pw.TableRow(
                        children: [
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(selectedProduct!)),
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(selectedBrand!)),
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(qtyController.text)),
                          pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(customerRateController.text)),
                        ]
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Text("Payment Done: ${paymentDone ? "Yes" : "No"}"),
              ],
            ),
          );
        },
      ),
    );

    // Share PDF directly
    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'deal_${DateTime.now().millisecondsSinceEpoch}.pdf'
    );
  }
}