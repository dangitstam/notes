import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
import 'package:notes/src/data/note_repository.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

part 'coffee_tasting_create_event.dart';
part 'coffee_tasting_create_state.dart';

class CoffeeTastingCreateBloc extends Bloc<CoffeeTastingCreateEvent, CoffeeTastingCreateState> {
  final coffeeTastingRepository = CoffeeTastingRepository();

  final noteRepository = NoteRepository();

  CoffeeTastingCreateBloc()
      : super(
          CoffeeTastingCreateState(
            isCoffeeTastingInserted: false,
            tasting: CoffeeTasting(
              coffeeName: '', // TODO: Require some fields in the create view.
              description: '',
              origin: '',
              roaster: '',
              process: 'Washed',
              roastLevel: 7.0,
              aromaScore: 7.0,
              aromaIntensity: 7.0,
              acidityScore: 7.0,
              acidityIntensity: 7.0,
              bodyScore: 7.0,
              bodyLevel: 7.0,
              sweetnessScore: 7.0,
              sweetnessIntensity: 7.0,
              finishScore: 7.0,
              finishDuration: 7.0,
              flavorScore: 7.0,
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

  Future<int> insertCoffeeTasting() async {
    final coffeeTastingId = await coffeeTastingRepository.insert(state.tasting);

    for (var note in state.tasting.notes) {
      var coffeeTastingNoteId = await noteRepository.insertNoteForCoffeeTasting(note.id, coffeeTastingId);
      if (coffeeTastingNoteId < 0) {
        // TODO: Logging
      }
    }

    return coffeeTastingId;
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
  Stream<CoffeeTastingCreateState> mapEventToState(
    CoffeeTastingCreateEvent event,
  ) async* {
    if (event is InsertCoffeeTastingEvent) {
      // Reflect in state whether the tasting was successfully inserted.
      var coffeeTastingId = await insertCoffeeTasting();
      yield state.copyWith(isCoffeeTastingInserted: coffeeTastingId > 0);
    } else if (event is AddCoffeeTastingNoteEvent) {
      // List<Note>.from makes a mutable copy of an immutable list.
      var newNotes = List<Note>.from(state.tasting.notes);
      newNotes.add(event.note);
      yield state.copyWith(
        tasting: state.tasting.copyWith(notes: newNotes),
      );
    } else if (event is RemoveCoffeeTastingNoteEvent) {
      var newNotes = List<Note>.from(state.tasting.notes);
      newNotes.remove(event.note);
      yield state.copyWith(
        tasting: state.tasting.copyWith(notes: newNotes),
      );
    } else if (event is CreateCoffeeTastingNoteEvent) {
      unawaited(insertCategorizedNote(event.note, event.noteCategory));
    } else if (event is CreateCoffeeTastingNoteCategoryEvent) {
      unawaited(insertNoteCategory(event.noteCategory));
    } else if (event is CoffeeNameEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(coffeeName: event.coffeeName),
      );
    } else if (event is DescriptionEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(description: event.description),
      );
    } else if (event is OriginEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(origin: event.origin),
      );
    } else if (event is RoasterEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(roaster: event.roaster),
      );
    } else if (event is RoastLevelEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(roastLevel: event.roastLevel),
      );
    } else if (event is ProcessEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(process: event.process),
      );
    } else if (event is AromaScoreEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(aromaScore: event.aromaScore),
      );
    } else if (event is AromaIntensityEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(aromaIntensity: event.aromaIntensity),
      );
    } else if (event is AcidityScoreEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(acidityScore: event.acidityScore),
      );
    } else if (event is AcidityIntensityEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(acidityIntensity: event.acidityIntensity),
      );
    } else if (event is BodyScoreEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(bodyScore: event.bodyScore),
      );
    } else if (event is BodyLevelEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(bodyLevel: event.bodyLevel),
      );
    } else if (event is SweetnessScoreEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(sweetnessScore: event.sweetnessScore),
      );
    } else if (event is SweetnessIntensityEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(sweetnessIntensity: event.sweetnessIntensity),
      );
    } else if (event is FinishScoreEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(finishScore: event.finishScore),
      );
    } else if (event is FinishDurationEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(finishDuration: event.finishDuration),
      );
    } else if (event is FlavorScoreEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(flavorScore: event.flavorScore),
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
