import 'package:equatable/equatable.dart';

class NoteToNoteCategory extends Equatable {
  final int note_id;
  final int note_category_id;

  NoteToNoteCategory({this.note_id, this.note_category_id});

  factory NoteToNoteCategory.fromAppDatabase(Map<String, dynamic> noteToNoteCategoryMap) {
    return NoteToNoteCategory(
      note_id: noteToNoteCategoryMap['note_id'],
      note_category_id: noteToNoteCategoryMap['note_category_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'note_id': note_id, 'note_category_id': note_category_id};
  }

  @override
  String toString() {
    return '{ \'note_id\': $note_id, \'note_category_id\': $note_category_id }';
  }

  @override
  List<Object> get props => [note_id, note_category_id];
}
