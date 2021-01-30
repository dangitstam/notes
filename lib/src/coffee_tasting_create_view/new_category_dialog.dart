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
            FlatButton(
              color: Theme.of(context).colorScheme.onSurface,
              child: Text('Create category'.toUpperCase(),
                  style:
                      Theme.of(context).textTheme.overline.copyWith(color: Colors.white, fontWeight: FontWeight.w300)),
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
