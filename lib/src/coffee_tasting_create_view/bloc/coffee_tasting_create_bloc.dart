import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/note_repository.dart';

part 'coffee_tasting_create_event.dart';
part 'coffee_tasting_create_state.dart';

class CoffeeTastingCreateBloc extends Bloc<CoffeeTastingCreateEvent, CoffeeTastingCreateState> {
  final coffeeTastingRepository = CoffeeTastingRepository();

  final noteRepository = NoteRepository();

  CoffeeTastingCreateBloc()
      : super(
          CoffeeTastingCreateState(
            isCoffeeTastingInserted: false,
            coffeeName: '', // TODO: Require some fields in the create view.
            description: '',
            origin: '',
            roaster: '',
            process: 'Washed',
            roastLevel: 7.0,
            acidityScore: 7.0,
            acidityIntensity: 7.0,
            finishScore: 7.0,
            bodyScore: 7.0,
            bodyLevel: 7.0,
            flavorScore: 7.0,
            aromaScore: 7.0,
            aromaIntensity: 7.0,
            sweetnessScore: 7.0,
            notes: <Note>[],
            imagePath: null,
          ),
        ) {
    // Initialize the stream of notes.
    refreshNotesStream();
  }

  Future<int> insertCoffeeTasting() async {
    final coffeeTastingId = await coffeeTastingRepository.insert(
      CoffeeTasting(
        coffeeName: state.coffeeName,
        description: state.description,
        origin: state.origin,
        process: state.process,
        roaster: state.roaster,
        // TODO: Where should the normalization take place?
        roastLevel: state.roastLevel / 10,
        acidityScore: state.acidityScore,
        bodyScore: state.bodyScore,
        finishScore: state.finishScore,
        flavorScore: state.flavorScore,
        aromaScore: state.aromaScore,
        imagePath: state.imagePath,
      ),
    );

    for (var note in state.notes) {
      var coffeeTastingNoteId = await noteRepository.insertNoteForCoffeeTasting(note.id, coffeeTastingId);
      if (coffeeTastingNoteId < 0) {
        // TODO: Logging
      }
    }

    return coffeeTastingId;
  }

  // Controller: Page <- App Database.
  final _getNotesController = StreamController<List<Note>>.broadcast();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<Note>> get _inNotes => _getNotesController.sink;

  void refreshNotesStream() async {
    // Retrieve all the notes from the database.
    var notes = await noteRepository.getAllNotes();

    // Update the notes output stream so subscribing pages can update.
    _inNotes.add(notes);
  }

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for notes.
  Stream<List<Note>> get notes => _getNotesController.stream.asBroadcastStream();

  Future<int> insert(Note note) async {
    final noteId = await noteRepository.insert(note);

    // Update output stream on every insertion.
    refreshNotesStream();

    return noteId;
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
      var newNotes = List<Note>.from(state.notes);
      newNotes.add(event.note);
      yield state.copyWith(notes: newNotes);
    } else if (event is RemoveCoffeeTastingNoteEvent) {
      var newNotes = List<Note>.from(state.notes);
      newNotes.remove(event.note);
      yield state.copyWith(notes: newNotes);
    } else if (event is CoffeeNameEvent) {
      yield state.copyWith(coffeeName: event.coffeeName);
    } else if (event is DescriptionEvent) {
      yield state.copyWith(description: event.description);
    } else if (event is OriginEvent) {
      yield state.copyWith(origin: event.origin);
    } else if (event is RoasterEvent) {
      yield state.copyWith(roaster: event.roaster);
    } else if (event is RoastLevelEvent) {
      yield state.copyWith(roastLevel: event.roastLevel);
    } else if (event is ProcessEvent) {
      yield state.copyWith(process: event.process);
    } else if (event is AromaScoreEvent) {
      yield state.copyWith(aromaScore: event.aromaScore);
    } else if (event is AromaIntensityEvent) {
      yield state.copyWith(aromaIntensity: event.aromaIntensity);
    } else if (event is AcidityScoreEvent) {
      yield state.copyWith(acidityScore: event.acidityScore);
    } else if (event is AcidityIntensityEvent) {
      yield state.copyWith(acidityIntensity: event.acidityIntensity);
    } else if (event is BodyScoreEvent) {
      yield state.copyWith(bodyScore: event.bodyScore);
    } else if (event is BodyLevelEvent) {
      yield state.copyWith(bodyLevel: event.bodyLevel);
    } else if (event is SweetnessScoreEvent) {
      yield state.copyWith(sweetnessScore: event.sweetnessScore);
    } else if (event is SweetnessIntensityEvent) {
      yield state.copyWith(sweetnessIntensity: event.sweetnessIntensity);
    } else if (event is FinishScoreEvent) {
      yield state.copyWith(finishScore: event.finishScore);
    } else if (event is FinishDurationEvent) {
      yield state.copyWith(finishDuration: event.finishDuration);
    } else if (event is FlavorScoreEvent) {
      yield state.copyWith(flavorScore: event.flavorScore);
    } else if (event is AddImageEvent) {
      yield state.copyWith(imagePath: event.imagePath);
    }
  }

  @override
  Future<void> close() {
    _getNotesController.close();

    return super.close();
  }
}
