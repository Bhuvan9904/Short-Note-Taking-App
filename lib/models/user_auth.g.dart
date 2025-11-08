// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAuthAdapter extends TypeAdapter<UserAuth> {
  @override
  final int typeId = 10;

  @override
  UserAuth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAuth(
      id: fields[0] as String,
      email: fields[1] as String,
      password: fields[2] as String,
      fullName: fields[3] as String,
      createdAt: fields[4] as DateTime,
      lastLoginAt: fields[5] as DateTime,
      isLoggedIn: fields[6] as bool,
      profilePicturePath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserAuth obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.fullName)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastLoginAt)
      ..writeByte(6)
      ..write(obj.isLoggedIn)
      ..writeByte(7)
      ..write(obj.profilePicturePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
