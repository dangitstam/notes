import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:provider/provider.dart';

class GrapeTextFields extends StatefulWidget {
  @required
  final Function(int) onUpdateVarietalName;
  @required
  final Function(int) onUpdateVarietalPercentage;
  @required
  final Function() onAddVarietal;

  GrapeTextFields({this.onUpdateVarietalName, this.onUpdateVarietalPercentage, this.onAddVarietal});

  @override
  _GrapeTextFieldsState createState() => _GrapeTextFieldsState();
}

class _GrapeTextFieldsState extends State<GrapeTextFields> {
  List<String> varietalNames = <String>[];
  List<int> varietalPercentages = <int>[];
  List<Widget> grapeFields = <Widget>[];
  int _numVarietals = 0;

  /// Override [didChangeDependencies] instead of [initState] so that theme
  /// changes can be picked up for dependent widgets.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String varietals = context.read<WineTastingCreateBloc>().state.tasting.varietals;
    print(varietals);
    if (varietals.isNotEmpty) {
      varietalNames = json.decode(varietals).cast<String>();
      for (var _ in varietalNames) {
        grapeFields.add(createNewGrapeFields(context, _numVarietals));
        _numVarietals++;
      }
    } else {
      varietalNames.add('');
      grapeFields.add(createNewGrapeFields(context, _numVarietals));
      _numVarietals++;
    }
  }

  void submitVarietals() {
    String varietalsJson = json.encode(varietalNames);
    context.read<WineTastingCreateBloc>().add(AddWineVarietalsEvent(varietals: varietalsJson));
  }

  void addGrapeFields() {
    varietalNames.add('');
    setState(() => grapeFields.add(createNewGrapeFields(context, _numVarietals)));
    _numVarietals++;
  }

  Widget createNewGrapeFields(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController()..text = varietalNames[index],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                    hintText: 'Grenache',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                  ),
                  onChanged: (value) {
                    varietalNames[index] = value;
                    submitVarietals();
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(width: 20),
              IntrinsicWidth(
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  maxLength: 3,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                    fillColor: Theme.of(context).colorScheme.onSurface,
                    hintText: '100',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    counterText: '',
                  ),
                  onChanged: (value) {},
                  style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '%',
                style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 20),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: grapeFields,
        ),
        TextButton(
          style: Theme.of(context).outlinedButtonTheme.style,
          child: Text('+ Add grape'.toUpperCase()),
          onPressed: () {
            addGrapeFields();
          },
        ),
      ],
    );
  }
}
