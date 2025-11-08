// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      baselineWPM: fields[1] as double,
      currentWPM: fields[2] as double,
      improvementPercentage: fields[3] as double,
      isPremium: fields[4] as bool,
      createdAt: fields[5] as DateTime,
      lastActiveAt: fields[6] as DateTime,
      streakDays: fields[7] as int,
      totalExercisesCompleted: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.baselineWPM)
      ..writeByte(2)
      ..write(obj.currentWPM)
      ..writeByte(3)
      ..write(obj.improvementPercentage)
      ..writeByte(4)
      ..write(obj.isPremium)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastActiveAt)
      ..writeByte(7)
      ..write(obj.streakDays)
      ..writeByte(8)
      ..write(obj.totalExercisesCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
