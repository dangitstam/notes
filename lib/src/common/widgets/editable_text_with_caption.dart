import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditableTextWithCaptionWidget extends StatelessWidget {
  final String label;
  final String hint;
  final String initialValue;
  final Function onChanged;

  EditableTextWithCaptionWidget({this.label, this.hint, this.initialValue, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            // border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(0),
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label.toUpperCase(),
            labelStyle: Theme.of(context).textTheme.overline),
        style: Theme.of(context).textTheme.bodyText2,
        initialValue: initialValue,
        onChanged: (value) => onChanged(value));
  }
}
