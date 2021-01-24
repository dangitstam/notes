import 'package:equatable/equatable.dart';

class NoteCategory extends Equatable {
  final int id;
  final String name;

  NoteCategory({this.id, this.name});

  factory NoteCategory.fromAppDatabase(Map<String, dynamic> noteMap) {
    return NoteCategory(
      id: noteMap['note_category_id'],
      name: noteMap['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'note_category_id': id,
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
