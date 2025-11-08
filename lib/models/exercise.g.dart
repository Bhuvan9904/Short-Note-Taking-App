// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 3;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      idealNotes: fields[3] as String,
      difficulty: fields[4] as ExerciseDifficulty,
      duration: fields[5] as int,
      category: fields[6] as ExerciseCategory,
      isPremium: fields[7] as bool,
      estimatedWPM: fields[8] as double,
      keyTerms: (fields[9] as List).cast<String>(),
      suggestedAbbreviations: (fields[10] as List).cast<String>(),
      audioFilePath: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.idealNotes)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.isPremium)
      ..writeByte(8)
      ..write(obj.estimatedWPM)
      ..writeByte(9)
      ..write(obj.keyTerms)
      ..writeByte(10)
      ..write(obj.suggestedAbbreviations)
      ..writeByte(11)
      ..write(obj.audioFilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseDifficultyAdapter extends TypeAdapter<ExerciseDifficulty> {
  @override
  final int typeId = 1;

  @override
  ExerciseDifficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseDifficulty.beginner;
      case 1:
        return ExerciseDifficulty.intermediate;
      case 2:
        return ExerciseDifficulty.advanced;
      default:
        return ExerciseDifficulty.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseDifficulty obj) {
    switch (obj) {
      case ExerciseDifficulty.beginner:
        writer.writeByte(0);
        break;
      case ExerciseDifficulty.intermediate:
        writer.writeByte(1);
        break;
      case ExerciseDifficulty.advanced:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseCategoryAdapter extends TypeAdapter<ExerciseCategory> {
  @override
  final int typeId = 2;

  @override
  ExerciseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExerciseCategory.business;
      case 1:
        return ExerciseCategory.academic;
      case 2:
        return ExerciseCategory.general;
      default:
        return ExerciseCategory.business;
    }
  }

  @override
  void write(BinaryWriter writer, ExerciseCategory obj) {
    switch (obj) {
      case ExerciseCategory.business:
        writer.writeByte(0);
        break;
      case ExerciseCategory.academic:
        writer.writeByte(1);
        break;
      case ExerciseCategory.general:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
