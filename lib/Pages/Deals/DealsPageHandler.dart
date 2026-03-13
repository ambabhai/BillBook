import 'package:billbook/Model/deal_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

mixin DealsPageHandler<T extends StatefulWidget> on State<T> {
  List<DealModel> deals = [];

  Future<void> loadDeals() async {
    var box = await Hive.openBox<DealModel>('dealsBox');
    setState(() {
      deals = box.values.toList();
    });
  }

  Future<void> deleteDeal(int index) async {
    var box = await Hive.openBox<DealModel>('dealsBox');
    await deals[index].delete(); // HiveObject delete
    setState(() {
      deals.removeAt(index);
    });
  }
}