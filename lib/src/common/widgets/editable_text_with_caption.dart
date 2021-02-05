import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditableTextWithCaptionWidget extends StatelessWidget {
  final String label;
  final String hint;
  final Function onChanged;

  EditableTextWithCaptionWidget({this.label, this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hintColor = Theme.of(context).hintColor;
    final hintStyle = Theme.of(context).textTheme.bodyText2.copyWith(color: hintColor);
    return TextField(
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            contentPadding: EdgeInsets.all(0),
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label.toUpperCase(),
            labelStyle: Theme.of(context).textTheme.overline.copyWith(fontSize: 12)),
        style: hintStyle,
        onChanged: (value) => onChanged(value));
  }
}
