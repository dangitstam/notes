class WineTastingNote {
  final int wine_tasting_id;
  final int note_id;

  WineTastingNote({this.wine_tasting_id, this.note_id});

  factory WineTastingNote.fromAppDatabase(Map<String, dynamic> wineTastingNoteMap) {
    return WineTastingNote(
      wine_tasting_id: wineTastingNoteMap['wine_tasting_id'],
      note_id: wineTastingNoteMap['note_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wine_tasting_id': wine_tasting_id,
      'note_id': note_id,
    };
  }
}
