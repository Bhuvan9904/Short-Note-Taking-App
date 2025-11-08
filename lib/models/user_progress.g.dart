// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 4;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      id: fields[0] as String,
      exerciseId: fields[1] as String,
      userNotes: fields[2] as String,
      score: fields[3] as double,
      wpm: fields[4] as double,
      accuracyScore: fields[5] as double,
      brevityScore: fields[6] as double,
      abbreviationUsage: fields[7] as double,
      completedAt: fields[8] as DateTime,
      timeSpent: fields[9] as int,
      missedKeyPoints: (fields[10] as List).cast<String>(),
      improvementSuggestions: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exerciseId)
      ..writeByte(2)
      ..write(obj.userNotes)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.wpm)
      ..writeByte(5)
      ..write(obj.accuracyScore)
      ..writeByte(6)
      ..write(obj.brevityScore)
      ..writeByte(7)
      ..write(obj.abbreviationUsage)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.timeSpent)
      ..writeByte(10)
      ..write(obj.missedKeyPoints)
      ..writeByte(11)
      ..write(obj.improvementSuggestions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
