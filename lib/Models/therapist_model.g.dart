// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'therapist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TherapistModelAdapter extends TypeAdapter<TherapistModel> {
  @override
  final int typeId = 0;

  @override
  TherapistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TherapistModel(
      name: fields[0] as String,
      gender: fields[1] as String,
      phone: fields[2] as String,
      altPhone: fields[3] as String,
      email: fields[4] as String,
      clinic: fields[5] as String,
      degrees: fields[6] as String,
      bio: fields[7] as String,
      experience: fields[8] as String,
      specialization: fields[9] as String,
      fees: fields[10] as String,
      documentPaths: (fields[11] as List).cast<String>(),
      doctorIdPath: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TherapistModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.altPhone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.clinic)
      ..writeByte(6)
      ..write(obj.degrees)
      ..writeByte(7)
      ..write(obj.bio)
      ..writeByte(8)
      ..write(obj.experience)
      ..writeByte(9)
      ..write(obj.specialization)
      ..writeByte(10)
      ..write(obj.fees)
      ..writeByte(11)
      ..write(obj.documentPaths)
      ..writeByte(12)
      ..write(obj.doctorIdPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TherapistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
