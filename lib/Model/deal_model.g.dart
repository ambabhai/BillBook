// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
      product: fields[2] as String,
      brand: fields[3] as String,
      qty: fields[4] as double,
      customerRate: fields[5] as double,
      supplierRate: fields[6] as double,
      paymentDone: fields[7] as bool,
      note: fields[8] as String,
      date: fields[9] as DateTime,
      profit: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DealModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.customer)
      ..writeByte(1)
      ..write(obj.supplier)
      ..writeByte(2)
      ..write(obj.product)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.qty)
      ..writeByte(5)
      ..write(obj.customerRate)
      ..writeByte(6)
      ..write(obj.supplierRate)
      ..writeByte(7)
      ..write(obj.paymentDone)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.profit);
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
