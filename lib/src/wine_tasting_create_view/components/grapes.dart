import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    String varietalsFromBloc = context.read<WineTastingCreateBloc>().state.tasting.varietals;
    String varietalPercentagesFromBloc = context.read<WineTastingCreateBloc>().state.tasting.varietalPercentages;
    if (varietalsFromBloc.isNotEmpty && varietalPercentagesFromBloc.isNotEmpty) {
      varietalNames = json.decode(varietalsFromBloc).cast<String>();
      varietalPercentages = json.decode(varietalPercentagesFromBloc).cast<int>();
      for (var _ in varietalNames) {
        addGrapeFieldsWithDefaultValues(addDefaults: false);
      }
    } else {
      addGrapeFieldsWithDefaultValues(addDefaults: true);
    }
  }

  int getVarietalPercentageSum() {
    return varietalPercentages.fold(0, (acc, v) => acc + v);
  }

  // TODO: Would be more efficient to call this when closing.
  void submitVarietals() {
    String varietalNamesJson = json.encode(varietalNames);
    String varietalPercentagesJson = json.encode(varietalPercentages);
    context.read<WineTastingCreateBloc>().add(AddWineVarietalsEvent(varietals: varietalNamesJson));
    context
        .read<WineTastingCreateBloc>()
        .add(AddWineVarietalPercentagesEvent(varietalPercentages: varietalPercentagesJson));
  }

  void addGrapeFieldsWithDefaultValues({bool addDefaults = false}) {
    if (addDefaults) {
      varietalNames.add('');

      // Each subsequent grape will compute and autofill the remaining percentage.
      int remainingPercent = max(100 - getVarietalPercentageSum(), 0);
      varietalPercentages.add(remainingPercent);
    }
    setState(() => grapeFields.add(createNewGrapeFields(context, _numVarietals)));
    _numVarietals++;
  }

  Widget createNewGrapeFields(BuildContext context, int index) {
    // Text controller for percentage that begins the cursor at the end of the form.
    final TextEditingController percentageController = TextEditingController(
      text: varietalPercentages[index].toString(),
    );

    final TextEditingController varietalController = TextEditingController(
      text: varietalNames[index].toString(),
    );
    varietalController.addListener(() {});

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: varietalController,
                  decoration: InputDecoration(
                    hintText: 'Grenache',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    varietalNames[index] = value;
                    submitVarietals();
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(width: 10),
              IntrinsicWidth(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: percentageController,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Icon(
                        CupertinoIcons.percent,
                        size: 16,
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: '100',
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    focusColor: Theme.of(context).colorScheme.primary,
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      varietalPercentages[index] = int.parse(value);
                    } else {
                      varietalPercentages[index] = 100;
                    }
                    percentageController.value = percentageController.value.copyWith(
                      text: value,
                      selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                    );
                    submitVarietals();
                  },
                  validator: (String value) {
                    // Percentage is required only when the varietal name is provided.
                    if (varietalNames[index].isNotEmpty && value.isEmpty) {
                      return 'Required';
                    }
                    if (value.isNotEmpty && getVarietalPercentageSum() > 100) {
                      return 'Too high!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: grapeFields,
        ),
        TextButton.icon(
          style: Theme.of(context).outlinedButtonTheme.style,
          icon: Icon(
            CupertinoIcons.add,
            size: 14,
          ),
          label: Text('Add grape'.toUpperCase()),
          onPressed: () {
            addGrapeFieldsWithDefaultValues(addDefaults: true);
          },
        ),
      ],
    );
  }
}
