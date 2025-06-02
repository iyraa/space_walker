// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NodeAdapter extends TypeAdapter<Node> {
  @override
  final int typeId = 1;

  @override
  Node read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Node(
      id: fields[0] as String,
      background: fields[1] as String,
      audio: fields[2] as String?,
      windowDisplay: fields[3] as String?,
      content: (fields[4] as List).cast<NodeContent>(),
    );
  }

  @override
  void write(BinaryWriter writer, Node obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.background)
      ..writeByte(2)
      ..write(obj.audio)
      ..writeByte(3)
      ..write(obj.windowDisplay)
      ..writeByte(4)
      ..write(obj.content);
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

class NodeContentAdapter extends TypeAdapter<NodeContent> {
  @override
  final int typeId = 2;

  @override
  NodeContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NodeContent(
      type: fields[0] as String,
      character: fields[1] as String?,
      narrative: fields[2] as String?,
      puzzleType: fields[3] as String?,
      description: fields[4] as String?,
      solution: fields[5] as String?,
      setFlag: (fields[6] as Map?)?.cast<String, bool>(),
      successMessage: fields[7] as String?,
      failureMessage: fields[8] as String?,
      symbols: (fields[9] as List?)?.cast<String>(),
      option: fields[10] as String?,
      nextNodeId: fields[11] as String?,
      condition: (fields[12] as Map?)?.cast<String, bool>(),
      systemLog: fields[13] as String?,
      id: fields[14] as String?,
      effects: (fields[15] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, NodeContent obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.character)
      ..writeByte(2)
      ..write(obj.narrative)
      ..writeByte(3)
      ..write(obj.puzzleType)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.solution)
      ..writeByte(6)
      ..write(obj.setFlag)
      ..writeByte(7)
      ..write(obj.successMessage)
      ..writeByte(8)
      ..write(obj.failureMessage)
      ..writeByte(9)
      ..write(obj.symbols)
      ..writeByte(10)
      ..write(obj.option)
      ..writeByte(11)
      ..write(obj.nextNodeId)
      ..writeByte(12)
      ..write(obj.condition)
      ..writeByte(13)
      ..write(obj.systemLog)
      ..writeByte(14)
      ..write(obj.id)
      ..writeByte(15)
      ..write(obj.effects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 3;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
