class WineTastingNote {
  final int coffee_tasting_id;
  final int note_id;

  WineTastingNote({this.coffee_tasting_id, this.note_id});

  factory WineTastingNote.fromAppDatabase(Map<String, dynamic> coffeeTastingNoteMap) {
    return WineTastingNote(
      coffee_tasting_id: coffeeTastingNoteMap['coffee_tasting_id'],
      note_id: coffeeTastingNoteMap['note_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coffee_tasting_id': coffee_tasting_id,
      'note_id': note_id,
    };
  }
}
