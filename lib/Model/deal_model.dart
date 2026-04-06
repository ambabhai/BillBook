import 'package:hive/hive.dart';

part 'deal_model.g.dart';

@HiveType(typeId: 1)
class DealItemModel {
  @HiveField(0)
  String product;

  @HiveField(1)
  String brand;

  @HiveField(2)
  double qty;

  @HiveField(3)
  double customerRate;

  @HiveField(4)
  double supplierRate;

  DealItemModel({
    required this.product,
    required this.brand,
    required this.qty,
    required this.customerRate,
    required this.supplierRate,
  });

  double get customerTotal => qty * customerRate;

  double get supplierTotal => qty * supplierRate;

  double get profit => customerTotal - supplierTotal;
}

@HiveType(typeId: 0)
class DealModel extends HiveObject {
  @HiveField(0)
  String customer;

  @HiveField(1)
  String supplier;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool paymentDone;

  @HiveField(4)
  bool orderCompleted;

  @HiveField(5)
  List<DealItemModel> items;

  DealModel({
    required this.customer,
    required this.supplier,
    required this.date,
    required this.paymentDone,
    required this.orderCompleted,
    required this.items,
  });

  double get totalQty {
    return items.fold(
      0,
          (sum, item) => sum + item.qty,
    );
  }

  double get totalCustomerAmount {
    return items.fold(
      0,
          (sum, item) => sum + item.customerTotal,
    );
  }

  double get totalSupplierAmount {
    return items.fold(
      0,
          (sum, item) => sum + item.supplierTotal,
    );
  }

  double get totalProfit {
    return items.fold(
      0,
          (sum, item) => sum + item.profit,
    );
  }
}