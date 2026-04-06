import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../Model/deal_model.dart';

mixin CreateDealHandler<T extends StatefulWidget> on State<T> {
  // Main Controllers
  final TextEditingController customerController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isDealSaved = false;

  // Lists
  List<String> products = [];
  List<String> brands = [];
  List<String> customers = [];
  List<String> suppliers = [];

  bool orderCompleted = false;

  // Live filter lists for autocomplete
  List<String> filteredCustomers = [];
  List<String> filteredSuppliers = [];

  // Dynamic Item Forms
  List<DealItemFormModel> itemForms = [
    DealItemFormModel(),
  ];


  void clearFormData() {
    customerController.clear();
    supplierController.clear();

    for (var item in itemForms) {
      item.qtyController.clear();
      item.customerRateController.clear();
      item.supplierRateController.clear();
    }

    itemForms.clear();
    itemForms.add(DealItemFormModel());

    orderCompleted = false;
    isDealSaved = false;
  }

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

  void addNewItemCard() {
    setState(() {
      itemForms.add(DealItemFormModel());
    });
  }

  void removeItemCard(int index) {
    if (itemForms.length == 1) return;

    setState(() {
      itemForms[index].dispose();
      itemForms.removeAt(index);
    });
  }

  void calculateItemProfit(int index) {
    final item = itemForms[index];

    double qty = double.tryParse(item.qtyController.text) ?? 0;
    double customerRate =
        double.tryParse(item.customerRateController.text) ?? 0;
    double supplierRate =
        double.tryParse(item.supplierRateController.text) ?? 0;

    setState(() {
      item.profit = (customerRate - supplierRate) * qty;
    });
  }

  void filterCustomer(String input) {
    setState(() {
      if (input.trim().isEmpty) {
        filteredCustomers = List.from(customers);
      } else {
        filteredCustomers = customers
            .where((c) => c.toLowerCase().contains(input.toLowerCase()))
            .toList();
      }
    });
  }

  void filterSupplier(String input) {
    setState(() {
      if (input.trim().isEmpty) {
        filteredSuppliers = List.from(suppliers);
      } else {
        filteredSuppliers = suppliers
            .where((s) => s.toLowerCase().contains(input.toLowerCase()))
            .toList();
      };
    });
  }

  Widget buildProductDropdown(int index) {
    final item = itemForms[index];

    return Row(
      children: [
        Expanded(
          child:
          DropdownButtonFormField<String>(
            value: products.contains(item.selectedProduct)
                ? item.selectedProduct
                : null,
            hint: const Text("Select Product"),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            selectedItemBuilder: (context) {
              return products.map((p) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    p,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList();
            },

            items: products.map((p) {
              return DropdownMenuItem<String>(
                value: p,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        p,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => confirmRemove('product', p),
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                item.selectedProduct = value;
              });
            },
          )        ),
        IconButton(
          onPressed: addProductDialog,
          icon: const Icon(Icons.add_circle, color: Colors.green),
        ),
      ],
    );
  }

  Widget buildBrandDropdown(int index) {
    final item = itemForms[index];

    return Row(
      children: [
        Expanded(
          child:
          DropdownButtonFormField<String>(
            value: brands.contains(item.selectedBrand)
                ? item.selectedBrand
                : null,
            hint: const Text("Select Brand"),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8F8F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),

            selectedItemBuilder: (context) {
              return brands.map((b) {
                return Text(
                  b,
                  overflow: TextOverflow.ellipsis,
                );
              }).toList();
            },

            items: brands.map((b) {
              return DropdownMenuItem<String>(
                value: b,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        b,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => confirmRemove('brand', b),
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                item.selectedBrand = value;
              });
            },
          )        ),
        IconButton(
          onPressed: addBrandDialog,
          icon: const Icon(Icons.add_circle, color: Colors.green),
        ),
      ],
    );
  }

  Future<void> saveDeal() async {
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

    var productBox = await Hive.openBox<String>('productsBox');
    var brandBox = await Hive.openBox<String>('brandsBox');
    var customerBox = await Hive.openBox<String>('customersBox');
    var supplierBox = await Hive.openBox<String>('suppliersBox');
    var dealsBox = await Hive.openBox<DealModel>('dealsBox');

    if (!customers.contains(customer)) {
      customers.add(customer);
      await customerBox.put(customer, customer);
    }

    if (!suppliers.contains(supplier)) {
      suppliers.add(supplier);
      await supplierBox.put(supplier, supplier);
    }

    List<DealItemModel> dealItems = [];

    for (var item in itemForms) {
      if (item.selectedProduct != null &&
          !products.contains(item.selectedProduct)) {
        products.add(item.selectedProduct!);
        await productBox.put(item.selectedProduct!, item.selectedProduct!);
      }

      if (item.selectedBrand != null &&
          !brands.contains(item.selectedBrand)) {
        brands.add(item.selectedBrand!);
        await brandBox.put(item.selectedBrand!, item.selectedBrand!);
      }

      dealItems.add(
        DealItemModel(
          product: item.selectedProduct ?? '',
          brand: item.selectedBrand ?? '',
          qty: double.tryParse(item.qtyController.text) ?? 0,
          customerRate:
          double.tryParse(item.customerRateController.text) ?? 0,
          supplierRate:
          double.tryParse(item.supplierRateController.text) ?? 0,
        ),
      );
    }

    await dealsBox.add(
      DealModel(
        customer: customer,
        supplier: supplier,
        date: selectedDate,
        paymentDone: itemForms.any((e) => e.paymentDone),
        orderCompleted: orderCompleted,
        items: dealItems,
      ),
    );

    setState(() {
      isDealSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Deal saved successfully"),
      ),
    );

    isDealSaved = true;
  }

  Future<void> saveDealIfNeeded() async {
    if (!isDealSaved) {
      await saveDeal();
    }
  }

  Future<void> showShareOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Share Bill",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Choose bill format",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.business_center,
                        color: Colors.blue,
                      ),
                    ),
                    title: const Text(
                      "Business Copy",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      "Includes profit and supplier details",
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      Navigator.pop(context);
                      await saveDealIfNeeded();
                      await shareDealPDF(isCustomerCopy: false);
                    },
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.green,
                      ),
                    ),
                    title: const Text(
                      "Customer Bill",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      "Simple bill without profit details",
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      Navigator.pop(context);
                      await saveDealIfNeeded();
                      await shareDealPDF(isCustomerCopy: true);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void resetForm() {
    customerController.clear();
    supplierController.clear();

    for (var item in itemForms) {
      item.dispose();
    }

    itemForms = [DealItemFormModel()];
    selectedDate = DateTime.now();
    orderCompleted = false;

    setState(() {});
  }

  void addProductDialog() {
    TextEditingController newController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Product"),
        content: TextField(
          controller: newController,
          decoration: const InputDecoration(
            hintText: "Enter product name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String value = newController.text.trim();

              if (value.isNotEmpty && !products.contains(value)) {
                products.add(value);
                var productBox = await Hive.openBox<String>('productsBox');
                await productBox.put(value, value);
              }

              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void addBrandDialog() {
    TextEditingController newController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Brand"),
        content: TextField(
          controller: newController,
          decoration: const InputDecoration(
            hintText: "Enter brand name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String value = newController.text.trim();

              if (value.isNotEmpty && !brands.contains(value)) {
                brands.add(value);
                var brandBox = await Hive.openBox<String>('brandsBox');
                await brandBox.put(value, value);
              }

              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void confirmRemove(String type, String name) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Remove Item"),
          content: Text("Do you want to remove '$name'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);

                if (type == 'product') {
                  await removeProduct(name);
                } else {
                  await removeBrand(name);
                }
              },
              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> removeProduct(String name) async {
    products.remove(name);

    for (var item in itemForms) {
      if (item.selectedProduct == name) {
        item.selectedProduct = null;
      }
    }

    var productBox = await Hive.openBox<String>('productsBox');
    await productBox.delete(name);

    setState(() {});
  }

  Future<void> removeBrand(String name) async {
    brands.remove(name);

    for (var item in itemForms) {
      if (item.selectedBrand == name) {
        item.selectedBrand = null;
      }
    }

    var brandBox = await Hive.openBox<String>('brandsBox');
    await brandBox.delete(name);

    setState(() {});
  }

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> shareDealPDF({required bool isCustomerCopy}) async {
    String customer = customerController.text.trim();
    String supplier = supplierController.text.trim();

    if (customer.isEmpty || supplier.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill customer and supplier"),
        ),
      );
      return;
    }

    final pdf = pw.Document();

    double totalQty = 0;
    double totalCustomerAmount = 0;
    double totalSupplierAmount = 0;
    double totalProfit = 0;

    for (var item in itemForms) {
      double qty = double.tryParse(item.qtyController.text) ?? 0;
      double customerRate =
          double.tryParse(item.customerRateController.text) ?? 0;
      double supplierRate =
          double.tryParse(item.supplierRateController.text) ?? 0;

      totalQty += qty;
      totalCustomerAmount += qty * customerRate;
      totalSupplierAmount += qty * supplierRate;
      totalProfit += item.profit;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 20),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "BUSINESS INVOICE",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        "Billing & Dill Summary",
                        style: pw.TextStyle(
                          fontSize: 11,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF2F2F2),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Text(
                      isCustomerCopy
                          ? "CUSTOMER COPY"
                          : "BUSINESS COPY",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info Section
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF8F8F8),
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(
                  color: PdfColor.fromInt(0xFFE2E2E2),
                ),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Customer Details",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(customer),
                        pw.SizedBox(height: 14),
                        if (!isCustomerCopy) ...[
                          pw.Text(
                            "Supplier Details",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(supplier),
                        ],
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 30),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          "Invoice Date",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        ),
                        pw.SizedBox(height: 14),
                        pw.Text(
                          "Order Status",
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          orderCompleted ? "Completed" : "Pending",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // Table
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromInt(0xFFDADADA),
                width: 1,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(2.2),
                1: const pw.FlexColumnWidth(1.8),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1.5),
                if (!isCustomerCopy) 4: const pw.FlexColumnWidth(1.5),
                if (!isCustomerCopy) 5: const pw.FlexColumnWidth(1.4),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFEFEFEF),
                  ),
                  children: [
                    tableHeader('Product'),
                    tableHeader('Brand'),
                    tableHeader('Qty'),
                    tableHeader('Customer Rate'),
                    if (!isCustomerCopy) tableHeader('Supplier Rate'),
                    if (!isCustomerCopy) tableHeader('Profit'),
                  ],
                ),

                ...itemForms.map((item) {
                  double qty = double.tryParse(item.qtyController.text) ?? 0;
                  double customerRate =
                      double.tryParse(item.customerRateController.text) ?? 0;
                  double supplierRate =
                      double.tryParse(item.supplierRateController.text) ?? 0;

                  double customerTotal = qty * customerRate;
                  double supplierTotal = qty * supplierRate;

                  return pw.TableRow(
                    children: [
                      tableCell(item.selectedProduct ?? ''),
                      tableCell(item.selectedBrand ?? ''),
                      tableCell(item.qtyController.text),
                      tableCell(customerTotal.toStringAsFixed(2)),
                      if (!isCustomerCopy)
                        tableCell(supplierTotal.toStringAsFixed(2)),
                      if (!isCustomerCopy)
                        tableCell(item.profit.toStringAsFixed(2)),
                    ],
                  );
                }),

                // Total Row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFFF5F5F5),
                  ),
                  children: [
                    tableTotalCell('Total'),
                    tableTotalCell('-'),
                    tableTotalCell(totalQty.toStringAsFixed(2)),
                    tableTotalCell(totalCustomerAmount.toStringAsFixed(2)),
                    if (!isCustomerCopy)
                      tableTotalCell(totalSupplierAmount.toStringAsFixed(2)),
                    if (!isCustomerCopy)
                      tableTotalCell(totalProfit.toStringAsFixed(2)),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 30),

            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 220,
                padding: const pw.EdgeInsets.all(14),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF7F7F7),
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(
                    color: PdfColor.fromInt(0xFFE0E0E0),
                  ),
                ),
                child: pw.Column(
                  children: [
                    summaryRow(
                      "Total Quantity",
                      totalQty.toStringAsFixed(2),
                    ),
                    pw.SizedBox(height: 8),
                    summaryRow(
                      "Customer Total",
                      totalCustomerAmount.toStringAsFixed(2),
                      isBold: true,
                    ),
                    if (!isCustomerCopy) ...[
                      pw.SizedBox(height: 8),
                      summaryRow(
                        "Supplier Total",
                        totalSupplierAmount.toStringAsFixed(2),
                      ),
                      pw.SizedBox(height: 8),
                      summaryRow(
                        "Net Profit",
                        totalProfit.toStringAsFixed(2),
                        isBold: true,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 40),

            pw.Divider(),

            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Text(
                "Thank you for choosing us !!",
                style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          ];
        },
      ),
    );

    final pdfBytes = await pdf.save();

    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: 'bill_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  pw.Widget tableTotalCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  pw.Widget tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget summaryRow(
      String title,
      String value, {
        bool isBold = false,
      }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontWeight:
            isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontSize: 11,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontWeight:
            isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // First clear or reset anything that uses controllers
    clearFormData();

    // Then dispose controllers
    customerController.dispose();
    supplierController.dispose();

    for (var item in itemForms) {
      item.dispose(); // make sure DealItemFormModel has a dispose() that disposes its controllers
    }

    super.dispose();
  }
}

class DealItemFormModel {
  String? selectedProduct;
  String? selectedBrand;

  final TextEditingController qtyController = TextEditingController();
  final TextEditingController customerRateController = TextEditingController();
  final TextEditingController supplierRateController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool paymentDone = false;
  double profit = 0;

  void dispose() {
    qtyController.dispose();
    customerRateController.dispose();
    supplierRateController.dispose();
    noteController.dispose();
  }
}