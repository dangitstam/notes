import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/coffee_tasting.dart';

import 'dart:async';

class CoffeeTastingBloc {
  // Singleton instantiation.
  static final CoffeeTastingBloc _instance = CoffeeTastingBloc._internal();

  factory CoffeeTastingBloc() {
    return _instance;
  }

  CoffeeTastingBloc._internal() {
    // Retrieve all the notes on initialization
    getCoffeeTastings();

    // Listens for changes to the addNoteController and calls _handleAddNote on change
    _addCoffeeTastingController.stream.listen(_handleAddCoffeeTasting);
  }

  Stream<List<CoffeeTasting>> get coffeeTastings =>
      _coffeeTastingController.stream;

  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream you'll be using.
  final _coffeeTastingController =
      StreamController<List<CoffeeTasting>>.broadcast();

  // Input stream. We add our notes to the stream using this variable.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings =>
      _coffeeTastingController.sink;

  // Output stream. This one will be used within our pages to display the notes.
  Stream<List<CoffeeTasting>> get notes => _coffeeTastingController.stream;

  // Input stream for adding new notes. We'll call this from our pages.
  final _addCoffeeTastingController =
      StreamController<CoffeeTasting>.broadcast();
  StreamSink<CoffeeTasting> get inAddCoffeeTasting =>
      _addCoffeeTastingController.sink;

  // All stream controllers you create should be closed within this function
  void dispose() {
    _coffeeTastingController.close();
    _addCoffeeTastingController.close();
  }

  void getCoffeeTastings() async {
    // Retrieve all the notes from the database
    var coffeeTastings = await AppDatabase.db.getAllCoffeeTastings();

    // Add all of the notes to the stream so we can grab them later from our pages
    _inCoffeeTastings.add(coffeeTastings);
  }

  void _handleAddCoffeeTasting(CoffeeTasting note) async {
    // Create the note in the database
    await AppDatabase.db.insert(note.toMap());

    // Retrieve all the notes again after one is added.
    // This allows our pages to update properly and display the
    // newly added note.
    getCoffeeTastings();
  }
}
