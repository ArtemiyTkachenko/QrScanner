// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QrCodeAdapter extends TypeAdapter<QrCode> {
  @override
  final int typeId = 0;

  @override
  QrCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QrCode()
      ..code = fields[0] as String?
      ..time = fields[1] as int?;
  }

  @override
  void write(BinaryWriter writer, QrCode obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
