// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyTaskModelAdapter extends TypeAdapter<MonthlyTaskModel> {
  @override
  final int typeId = 2;

  @override
  MonthlyTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyTaskModel(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      total: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyTaskModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
