// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DealItemModelAdapter extends TypeAdapter<DealItemModel> {
  @override
  final int typeId = 1;

  @override
  DealItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealItemModel(
      product: fields[0] as String,
      brand: fields[1] as String,
      qty: fields[2] as double,
      customerRate: fields[3] as double,
      supplierRate: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DealItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.qty)
      ..writeByte(3)
      ..write(obj.customerRate)
      ..writeByte(4)
      ..write(obj.supplierRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DealModelAdapter extends TypeAdapter<DealModel> {
  @override
  final int typeId = 0;

  @override
  DealModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealModel(
      customer: fields[0] as String,
      supplier: fields[1] as String,
      date: fields[2] as DateTime,
      paymentDone: fields[3] as bool,
      orderCompleted: fields[4] as bool,
      items: (fields[5] as List).cast<DealItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DealModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.customer)
      ..writeByte(1)
      ..write(obj.supplier)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.paymentDone)
      ..writeByte(4)
      ..write(obj.orderCompleted)
      ..writeByte(5)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
