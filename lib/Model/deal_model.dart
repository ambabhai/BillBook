import 'package:hive/hive.dart';

part 'deal_model.g.dart';

@HiveType(typeId: 0)
class DealModel extends HiveObject {
  @HiveField(0)
  String customer;

  @HiveField(1)
  String supplier;

  @HiveField(2)
  String product;

  @HiveField(3)
  String brand;

  @HiveField(4)
  double qty;

  @HiveField(5)
  double customerRate;

  @HiveField(6)
  double supplierRate;

  @HiveField(7)
  bool paymentDone;

  @HiveField(8)
  String note;

  @HiveField(9)
  DateTime date;

  @HiveField(10)
  double profit; // <--- Add this

  DealModel({
    required this.customer,
    required this.supplier,
    required this.product,
    required this.brand,
    required this.qty,
    required this.customerRate,
    required this.supplierRate,
    required this.paymentDone,
    required this.note,
    required this.date,
    required this.profit, // <--- Add this
  });
}