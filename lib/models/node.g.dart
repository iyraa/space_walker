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
      background: fields[1] as String,
      dialogues: (fields[2] as List).cast<DialogueLine>(),
      choices: (fields[3] as List).cast<Choice>(),
    );
  }

  @override
  void write(BinaryWriter writer, Node obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.background)
      ..writeByte(2)
      ..write(obj.dialogues)
      ..writeByte(3)
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

class DialogueLineAdapter extends TypeAdapter<DialogueLine> {
  @override
  final int typeId = 1;

  @override
  DialogueLine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DialogueLine(
      character: fields[0] as String,
      narrative: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DialogueLine obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.character)
      ..writeByte(1)
      ..write(obj.narrative);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogueLineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChoiceAdapter extends TypeAdapter<Choice> {
  @override
  final int typeId = 2;

  @override
  Choice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Choice(
      option: fields[0] as String,
      condition: (fields[1] as Map?)?.cast<String, int>(),
      setFlag: (fields[2] as Map?)?.cast<String, int>(),
      nextScene: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Choice obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.option)
      ..writeByte(1)
      ..write(obj.condition)
      ..writeByte(2)
      ..write(obj.setFlag)
      ..writeByte(3)
      ..write(obj.nextScene);
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
