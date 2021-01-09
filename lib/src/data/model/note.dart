import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Note extends Equatable {
  final int id;
  final String name;
  final String color;

  Note({this.id, this.name, this.color});

  /// Given a Map<String, dynamic> resulting from querying a note
  /// from the `notes` table, maps the result to a Note.
  factory Note.fromAppDatabase(Map<String, dynamic> noteMap) {
    return Note(
      id: noteMap['note_id'],
      name: noteMap['name'],
      color: noteMap['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'note_id': id,
      'name': name,
      'color': color,
    };
  }

  /// Returns a `color` object containing this note's color.
  /// Assumes the note color is stored in the form #RRGGBB.
  Color getColor() {
    return Color(int.parse(color.substring(1, 7), radix: 16) + 0xff000000);
  }

  @override
  String toString() {
    return '$name';
  }

  @override
  // TODO: implement props
  List<Object> get props => [id, name, color];
}
