import 'package:flutter/material.dart';
import '../../Model/deal_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DealItemFormModel {
  final TextEditingController productController;
  final TextEditingController brandController;
  final TextEditingController qtyController;
  final TextEditingController customerRateController;
  final TextEditingController supplierRateController;

  DealItemFormModel({
    required String product,
    required String brand,
    required double qty,
    required double customerRate,
    required double supplierRate,
  })  : productController = TextEditingController(text: product),
        brandController = TextEditingController(text: brand),
        qtyController = TextEditingController(text: qty.toString()),
        customerRateController = TextEditingController(text: customerRate.toString()),
        supplierRateController = TextEditingController(text: supplierRate.toString());

  void dispose() {
    productController.dispose();
    brandController.dispose();
    qtyController.dispose();
    customerRateController.dispose();
    supplierRateController.dispose();
  }

  DealItemModel toDealItemModel() {
    return DealItemModel(
      product: productController.text,
      brand: brandController.text,
      qty: double.tryParse(qtyController.text) ?? 0,
      customerRate: double.tryParse(customerRateController.text) ?? 0,
      supplierRate: double.tryParse(supplierRateController.text) ?? 0,
    );
  }
}

mixin EditDealHandler<T extends StatefulWidget> on State<T> {
  final TextEditingController customerController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  DateTime date = DateTime.now();
  bool paymentDone = false;
  bool orderCompleted = false;

  List<DealItemFormModel> itemForms = [];

  void clearFormData() {
    customerController.clear();
    supplierController.clear();

    for (var item in itemForms) {
      item.dispose();
    }
    itemForms.clear();
  }

  Future<void> shareDealPDF({required bool isCustomerCopy}) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(isCustomerCopy ? "Customer Copy PDF" : "Business Copy PDF"),
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}