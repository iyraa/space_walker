// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NodeAdapter extends TypeAdapter<Node> {
  @override
  final int typeId = 0;

  @override
  Node read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Node(
      id: fields[0] as String,
      narrative: fields[1] as String,
      character: fields[2] as String,
      background: fields[3] as String,
      choices: (fields[4] as List).cast<Choice>(),
    );
  }

  @override
  void write(BinaryWriter writer, Node obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.narrative)
      ..writeByte(2)
      ..write(obj.character)
      ..writeByte(3)
      ..write(obj.background)
      ..writeByte(4)
      ..write(obj.choices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChoiceAdapter extends TypeAdapter<Choice> {
  @override
  final int typeId = 1;

  @override
  Choice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Choice(
      text: fields[0] as String,
      next: fields[1] as String,
      setFlag: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Choice obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.next)
      ..writeByte(2)
      ..write(obj.setFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
