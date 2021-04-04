import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/data/note_repository.dart';
import 'package:notes/src/data/wine_tasting_repository.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

part 'wine_tasting_create_event.dart';
part 'wine_tasting_create_state.dart';

class WineTastingCreateBloc extends Bloc<WineTastingCreateEvent, WineTastingCreateState> {
  final wineTastingRepository = WineTastingRepository();

  final noteRepository = NoteRepository();

  WineTastingCreateBloc({
    WineTasting initTasting,
  }) : super(
          WineTastingCreateState(
            isWineTastingInserted: false,
            tasting: initTasting ??
                WineTasting(
                  name: '', // TODO: Require some fields in the create view.
                  description: '',
                  origin: '',
                  winemaker: '',
                  varietalNames: '',
                  varietalPercentages: '',
                  alcoholByVolume: -1.0, // Use a negative value to signal as unspecified.
                  wineType: '',
                  bubbles: '',
                  isBiodynamic: false,
                  isOrganicFarming: false,
                  isUnfinedUnfiltered: false,
                  isWildYeast: false,
                  isNoAddedSulfites: false,
                  isEthicallyMade: false,
                  vintage: -1, // Use a negative value to signal as unspecified.
                  acidity: 0,
                  sweetness: 0,
                  tannin: 0,
                  body: 0,
                  notes: <Note>[],
                  imagePath: null,
                ),
          ),
        ) {
    // Initialize the stream of notes.
    refreshNotesStream();
    refreshCategorizedNotesStream();
  }

  // Controller: Page <- App Database.
  final _getNotesController = StreamController<List<Note>>.broadcast();

  // BehaviorSubject allows subsequent screens that receive this BLoC to retrieve the last drip.
  final _getNotesCategorizedController = BehaviorSubject<Map<NoteCategory, List<Note>>>();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<Note>> get _inNotes => _getNotesController.sink;
  StreamSink<Map<NoteCategory, List<Note>>> get _inNotesCategorized => _getNotesCategorizedController.sink;

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for notes.
  Stream<List<Note>> get notes => _getNotesController.stream.asBroadcastStream();
  Stream<Map<NoteCategory, List<Note>>> get notesCategorized =>
      _getNotesCategorizedController.stream.asBroadcastStream();

  void refreshNotesStream() async {
    // Retrieve all the notes from the database.
    var notes = await noteRepository.getAllNotes();

    // Update the notes output stream so subscribing pages can update.
    _inNotes.add(notes);
  }

  void refreshCategorizedNotesStream() async {
    // Retrieve all the notes (categorized) from the database.
    var notesCategorized = await noteRepository.getNotesCategorized();

    // Update the notes (categorized) output stream so subscribing pages can update.
    _inNotesCategorized.add(notesCategorized);
  }

  Future<int> insertWineTasting() async {
    final wineTastingId = await wineTastingRepository.insert(state.tasting);

    for (var note in state.tasting.notes) {
      var wineTastingNoteId = await noteRepository.insertNoteForWineTasting(note.id, wineTastingId);
      if (wineTastingNoteId < 0) {
        // TODO: Logging
      }
    }

    return wineTastingId;
  }

  Future<void> insertCategorizedNote(Note note, NoteCategory noteCategory) async {
    final noteId = await noteRepository.insert(note);
    final noteCategoryId = noteCategory.id;

    // ignore: unused_local_variable
    final noteToNoteCategoryId = await noteRepository.insertNoteToNoteCategory(noteId, noteCategoryId);

    // Update output stream on every insertion.
    refreshNotesStream();
    refreshCategorizedNotesStream();
  }

  Future<void> insertNoteCategory(NoteCategory noteCategory) async {
    // ignore: unused_local_variable
    final noteToNoteCategoryId = await noteRepository.insertNoteCategory(noteCategory);
    refreshCategorizedNotesStream();
  }

  @override
  Stream<WineTastingCreateState> mapEventToState(
    WineTastingCreateEvent event,
  ) async* {
    if (event is InsertWineTastingEvent) {
      // Reflect in state whether the tasting was successfully inserted.
      var wineTastingId = await insertWineTasting();
      yield state.copyWith(isWineTastingInserted: wineTastingId > 0);
    } else if (event is AddWineTastingNoteEvent) {
      // List<Note>.from makes a mutable copy of an immutable list.
      var newNotes = List<Note>.from(state.tasting.notes);
      newNotes.add(event.note);
      yield state.copyWith(
        tasting: state.tasting.copyWith(notes: newNotes),
      );
    } else if (event is RemoveWineTastingNoteEvent) {
      var newNotes = List<Note>.from(state.tasting.notes);
      newNotes.remove(event.note);
      yield state.copyWith(
        tasting: state.tasting.copyWith(notes: newNotes),
      );
    } else if (event is CreateWineTastingNoteEvent) {
      unawaited(insertCategorizedNote(event.note, event.noteCategory));
    } else if (event is CreateWineTastingNoteCategoryEvent) {
      unawaited(insertNoteCategory(event.noteCategory));
    } else if (event is NameEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(name: event.name),
      );
    } else if (event is DescriptionEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(description: event.description),
      );
    } else if (event is OriginEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(origin: event.origin),
      );
    } else if (event is AddWinemakerEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(winemaker: event.winemaker),
      );
    } else if (event is AddWineVarietalNamesEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(varietalNames: event.varietalNames),
      );
    } else if (event is AddWineVarietalPercentagesEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(varietalPercentages: event.varietalPercentages),
      );
    } else if (event is AddAlcoholByVolumeEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(alcoholByVolume: event.alcoholByVolume),
      );
    } else if (event is AddWineTypeEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(wineType: event.wineType),
      );
    } else if (event is AddBubblesEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(bubbles: event.bubbles),
      );
    } else if (event is SetIsBiodynamicEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(isBiodynamic: event.isBiodynamic),
      );
    } else if (event is SetIsOrganicFarmingEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(isOrganicFarming: event.isOrganicFarming),
      );
    } else if (event is SetIsUnfinedUnfilteredEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(isUnfinedUnfiltered: event.isUnfinedUnfiltered),
      );
    } else if (event is SetIsWildYeastEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(isWildYeast: event.isWildYeast),
      );
    } else if (event is SetIsNoAddedSulfitesEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(isNoAddedSulfites: event.isNoAddedSulfites),
      );
    } else if (event is SetIsEthicallyMadeEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(isEthicallyMade: event.isEthicallyMade),
      );
    } else if (event is AddVintageEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(vintage: event.vintage),
      );
    } else if (event is AddAcidityIntensityEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(acidity: event.acidityIntensity),
      );
    } else if (event is AddBodyIntensity) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(body: event.bodyIntensity),
      );
    } else if (event is AddSweetnessIntensityEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(sweetness: event.sweetnessIntensity),
      );
    } else if (event is AddTanninIntensityEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(tannin: event.tanninIntensity),
      );
    } else if (event is AddImageEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(imagePath: event.imagePath),
      );
    }
  }

  @override
  Future<void> close() {
    _getNotesController.close();
    _getNotesCategorizedController.close();
    return super.close();
  }
}
