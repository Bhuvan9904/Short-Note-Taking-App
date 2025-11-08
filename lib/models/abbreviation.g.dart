// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abbreviation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AbbreviationAdapter extends TypeAdapter<Abbreviation> {
  @override
  final int typeId = 6;

  @override
  Abbreviation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Abbreviation(
      id: fields[0] as String,
      fullWord: fields[1] as String,
      abbreviation: fields[2] as String,
      category: fields[3] as AbbreviationCategory,
      frequency: fields[4] as int,
      isUserCreated: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      description: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Abbreviation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullWord)
      ..writeByte(2)
      ..write(obj.abbreviation)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.isUserCreated)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbbreviationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AbbreviationCategoryAdapter extends TypeAdapter<AbbreviationCategory> {
  @override
  final int typeId = 5;

  @override
  AbbreviationCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AbbreviationCategory.business;
      case 1:
        return AbbreviationCategory.common;
      case 2:
        return AbbreviationCategory.custom;
      default:
        return AbbreviationCategory.business;
    }
  }

  @override
  void write(BinaryWriter writer, AbbreviationCategory obj) {
    switch (obj) {
      case AbbreviationCategory.business:
        writer.writeByte(0);
        break;
      case AbbreviationCategory.common:
        writer.writeByte(1);
        break;
      case AbbreviationCategory.custom:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AbbreviationCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
