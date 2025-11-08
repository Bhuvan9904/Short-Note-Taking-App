// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiveSessionAdapter extends TypeAdapter<LiveSession> {
  @override
  final int typeId = 8;

  @override
  LiveSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiveSession(
      id: fields[0] as String,
      transcript: fields[1] as String,
      userNotes: fields[2] as String,
      duration: fields[3] as int,
      score: fields[4] as double,
      sessionType: fields[5] as SessionType,
      completedAt: fields[6] as DateTime,
      audioFilePath: fields[7] as String?,
      transcriptionAccuracy: fields[8] as double,
      keyPointsCaptured: (fields[9] as List).cast<String>(),
      missedPoints: (fields[10] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, LiveSession obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.transcript)
      ..writeByte(2)
      ..write(obj.userNotes)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.score)
      ..writeByte(5)
      ..write(obj.sessionType)
      ..writeByte(6)
      ..write(obj.completedAt)
      ..writeByte(7)
      ..write(obj.audioFilePath)
      ..writeByte(8)
      ..write(obj.transcriptionAccuracy)
      ..writeByte(9)
      ..write(obj.keyPointsCaptured)
      ..writeByte(10)
      ..write(obj.missedPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiveSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 7;

  @override
  SessionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionType.meeting;
      case 1:
        return SessionType.lecture;
      case 2:
        return SessionType.practice;
      default:
        return SessionType.meeting;
    }
  }

  @override
  void write(BinaryWriter writer, SessionType obj) {
    switch (obj) {
      case SessionType.meeting:
        writer.writeByte(0);
        break;
      case SessionType.lecture:
        writer.writeByte(1);
        break;
      case SessionType.practice:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
