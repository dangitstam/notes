import 'package:equatable/equatable.dart';

class NoteCategory extends Equatable {
  final int id;
  final String name;

  NoteCategory({this.id, this.name});

  factory NoteCategory.fromAppDatabase(Map<String, dynamic> noteMap) {
    return NoteCategory(
      id: noteMap['note_id'],
      name: noteMap['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'note_id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return '$name';
  }

  @override
  List<Object> get props => [id, name];
}
