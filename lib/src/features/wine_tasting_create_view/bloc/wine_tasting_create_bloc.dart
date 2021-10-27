import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
import 'package:notes/src/data/model/slider/slider.dart';
import 'package:notes/src/data/model/wine/characteristic.dart';
import 'package:notes/src/data/model/wine/varietal.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/data/note_repository.dart';
import 'package:notes/src/data/slider_repository.dart';
import 'package:notes/src/data/varietal_repository.dart';
import 'package:notes/src/data/wine_tasting_repository.dart';
import 'package:path/path.dart' show basename;
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';

part 'wine_tasting_create_event.dart';
part 'wine_tasting_create_state.dart';

class WineTastingCreateBloc extends Bloc<WineTastingCreateEvent, WineTastingCreateState> {
  final wineTastingRepository = WineTastingRepository();
  final noteRepository = NoteRepository();
  final varietalRepository = VarietalRepository();
  final sliderRepository = SliderRepository();

  Map<String, Characteristic> characteristics = {};

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
                  varietals: <Varietal>[],
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
                  characteristics: [],
                  body: 0,
                  notes: <Note>[],
                  imageFileName: null,
                  imageUrl: null,
                  story: '',
                ),
            pickedImage: null,
          ),
        ) {
    // Initialize the stream of notes.
    refreshNotesStream();
    refreshCategorizedNotesStream();

    // Initialize the stream of sliders.
    refreshSlidersStreamAndCharacteristics();
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

  /// Custom Sliders Stream
  // Controller: Page <- App Database.
  final _getSlidersController = BehaviorSubject<List<CustomSlider>>();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CustomSlider>> get _inSliders => _getSlidersController.sink;

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for notes.
  Stream<List<CustomSlider>> get sliders => _getSlidersController.stream.asBroadcastStream();

  void refreshSlidersStreamAndCharacteristics() async {
    // Retrieve all the notes from the database.
    var sliders = await sliderRepository.getAllSliders();

    sliders.asMap().forEach((index, slider) {
      characteristics[slider.name] = Characteristic(
        name: slider.name,
        minLabel: slider.minLabel,
        maxLabel: slider.maxLabel,
      );
    });

    // Update the notes output stream so subscribing pages can update.
    _inSliders.add(sliders);
  }

  /// The user selects a file, and the task is added to the list.
  Future<firebase_storage.UploadTask> uploadFile(String uid, File file) async {
    if (file == null) {
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user')
        .child(uid)
        .child('tasting-image_${DateTime.now()}.jpg');

    final metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(file, metadata);
    }

    return Future.value(uploadTask);
  }

  /// Submits the current tasting for the given user.
  ///
  /// Return true on success.
  Future<bool> insertWineTasting(String uid) async {
    // TODO: Deprecate SQLite storage of all tastings.
    // SQLite upload.
    // --------------

    // final wineTastingId = await wineTastingRepository.insert(state.tasting);

    // for (var note in state.tasting.notes) {
    //   var wineTastingNoteId = await noteRepository.insertNoteForWineTasting(note.id, wineTastingId);
    //   if (wineTastingNoteId < 0) {
    //     // TODO: Logging
    //   }
    // }

    // for (var varietal in state.tasting.varietals) {
    //   var wineTastingVarietalId = await varietalRepository.insertVarietalForWine(wineTastingId, varietal);
    //   if (wineTastingVarietalId < 0) {
    //     // TODO: Logging
    //   }
    // }

    // Firebase upload.
    // ----------------

    // Upload image to cloud storage.
    // TODO: Upload will fail without an internet connection.
    // Possible solution is to
    // 1. Create a new Firestore collection (mobile-uploads?) containing pending mobile uploads
    //     * Documents should have an is_file_uploaded (bool) and is_mobile_document_uploaded (bool)
    //     * is_mobile_document_uploaded signals that the pending write to Cloud Firestore has completed
    //     * is_file_uploaded signals that the image has been stored in Cloud Storage
    //     * Also store a file name so that the image can be accessed locally
    // 2. Use a cloud function to listen to mobile-uploads
    //     * On change, set is_mobile_document_uploaded to true
    // 3. Create a long-running process in the app that listens to mobile-uploads
    //     * Collect only entries such that is_mobile_document_uploaded is true and is_file_uploaded is false
    //     * Once entries are collected, upload the image using the stored local file path
    //     * When the file is uploaded, the tasting document should be updated with the remote image URL by
    //       another cloud function.
    firebase_storage.UploadTask uploadTask = await uploadFile(uid, state.pickedImage);

    if (uploadTask != null) {
      // Upload a tasting with an image.
      await uploadTask.whenComplete(() async {
        String cloudImageUrl = await uploadTask.snapshot.ref.getDownloadURL();

        cloud_firestore.CollectionReference userTastings =
            cloud_firestore.FirebaseFirestore.instance.collection('user').doc(uid).collection('tastings');

        await userTastings.add(
          state.tasting.copyWith(imageUrl: cloudImageUrl).toMap(),
        );
      });
    } else {
      // Upload without an image.
      cloud_firestore.CollectionReference userTastings =
          cloud_firestore.FirebaseFirestore.instance.collection('user').doc(uid).collection('tastings');

      await userTastings.add(
        state.tasting.toMap(),
      );
    }

    return true;
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
      yield state.copyWith(isWineTastingInserted: await insertWineTasting(event.uid));
    } else if (event is AddWineTastingNoteEvent) {
      // List<Note>.from makes a mutable shallow copy of an immutable list.
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
    } else if (event is AddWineVarietalsEvent) {
      yield state.copyWith(
        tasting: state.tasting.copyWith(varietals: event.varietals),
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
    } else if (event is AddNewCharacteristic) {
      // Insert the new custom slider.
      await sliderRepository.insert(
        CustomSlider(
          name: event.name,
          minLabel: event.minLabel,
          maxLabel: event.maxLabel,
        ),
      );

      // Refresh
      refreshSlidersStreamAndCharacteristics();
      yield state;
    } else if (event is EditCharacteristic) {
      characteristics[event.name] = characteristics[event.name].copyWith(
        value: event.value,
      );

      yield state.copyWith(
        tasting: state.tasting.copyWith(
          characteristics: characteristics.values.toList(),
        ),
      );
    } else if (event is AddImageEvent) {
      yield state.copyWith(
        pickedImage: event.image,
        tasting: state.tasting.copyWith(
          imageFileName: basename(event.image.path),
        ),
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
