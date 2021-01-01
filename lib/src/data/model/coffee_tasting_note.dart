class CoffeeTastingNote {
  final int coffee_tasting_id;
  final int note_id;

  CoffeeTastingNote({this.coffee_tasting_id, this.note_id});

  factory CoffeeTastingNote.fromAppDatabase(
      Map<String, dynamic> coffeeTastingNoteMap) {
    return CoffeeTastingNote(
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
