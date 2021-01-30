import 'package:flutter/material.dart';
import 'package:notes/src/common/util.dart';

class NewCategoryDialog extends StatefulWidget {
  final Function(String) onSubmitted;

  NewCategoryDialog({this.onSubmitted});

  @override
  _NewCategoryDialogState createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  String _value;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Wrap(
          runSpacing: 20,
          children: [
            Center(child: Text('New note category')),
            EditableTextWithCaptionWidget(
              label: 'Name',
              hint: 'Dried fruit, cheeses, custom...',
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            TextButton(
              child: Text('Create category'.toUpperCase()),
              style: Theme.of(context).textButtonTheme.style,
              onPressed: () {
                widget.onSubmitted(_value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
