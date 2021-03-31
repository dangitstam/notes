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
    final hintColor = Theme.of(context).hintColor;
    final hintStyle = Theme.of(context).textTheme.bodyText2.copyWith(color: hintColor);
    return TextFormField(
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            contentPadding: EdgeInsets.all(0),
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label.toUpperCase(),
            labelStyle: Theme.of(context).textTheme.overline),
        style: hintStyle,
        initialValue: initialValue,
        onChanged: (value) => onChanged(value));
  }
}
