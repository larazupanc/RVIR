// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposleni_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZaposleniAdapter extends TypeAdapter<Zaposleni> {
  @override
  final int typeId = 0;

  @override
  Zaposleni read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zaposleni(
      ime: fields[0] as String,
      priimek: fields[1] as String,
      delovnoMesto: fields[2] as String,
      datumRojstva: fields[3] as DateTime,
      uraPrihoda: fields[4] as DateTime,
      uraOdhoda: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Zaposleni obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.ime)
      ..writeByte(1)
      ..write(obj.priimek)
      ..writeByte(2)
      ..write(obj.delovnoMesto)
      ..writeByte(3)
      ..write(obj.datumRojstva)
      ..writeByte(4)
      ..write(obj.uraPrihoda)
      ..writeByte(5)
      ..write(obj.uraOdhoda);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZaposleniAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
