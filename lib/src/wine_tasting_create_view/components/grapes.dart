import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/keys.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:provider/provider.dart';

class GrapeTextFields extends StatefulWidget {
  GrapeTextFields() : super(key: WidgetKeys.grapeTextFields);

  @override
  GrapeTextFieldsState createState() => GrapeTextFieldsState();
}

class GrapeTextFieldsState extends State<GrapeTextFields> {
  List<String> varietalNames = <String>[];
  List<int> varietalPercentages = <int>[];
  List<Widget> grapeFields = <Widget>[];
  int _numVarietals = 0;
  int _totalPercentage = 0;

  /// Override [didChangeDependencies] instead of [initState] so that theme
  /// changes can be picked up for dependent widgets.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WineTasting currentTasting = context.read<WineTastingCreateBloc>().state.tasting;
    String varietalsFromBloc = currentTasting.varietals;
    String varietalPercentagesFromBloc = currentTasting.varietalPercentages;

    if (varietalsFromBloc.isNotEmpty && varietalPercentagesFromBloc.isNotEmpty) {
      varietalNames = json.decode(varietalsFromBloc).cast<String>();
      varietalPercentages = json.decode(varietalPercentagesFromBloc).cast<int>();
      for (var _ in varietalNames) {
        addGrapeFieldsWithDefaultValues(addDefaults: false);
      }
    } else {
      addGrapeFieldsWithDefaultValues(addDefaults: true);
    }

    _totalPercentage = getVarietalPercentageSum();
  }

  int getVarietalPercentageSum() {
    return varietalPercentages.fold(0, (acc, v) => acc + v);
  }

  void updateTotalPercentage() {
    _totalPercentage = getVarietalPercentageSum();
  }

  void updateVarietalPercentage(int value, int index) {
    varietalPercentages[index] = value;
    updateTotalPercentage();
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

    updateTotalPercentage();
  }

  Widget createNewGrapeFields(BuildContext context, int index) {
    // Text controller for percentage that begins the cursor at the end of the form.
    final TextEditingController percentageController = TextEditingController(
      text: varietalPercentages[index].toString(),
    );

    final TextEditingController varietalController = TextEditingController(
      text: varietalNames[index].toString(),
    );

    // Custom input decoration.
    var customInputDecoration = InputDecoration(
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
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /**
               * Varietal name form.
               */
              Expanded(
                child: TextFormField(
                  controller: varietalController,
                  decoration: customInputDecoration.copyWith(hintText: 'Enter grape name'),
                  onChanged: (value) {
                    varietalNames[index] = value;
                    submitVarietals();
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const SizedBox(width: 10),
              /**
               * Varietal percentage form.
               */
              IntrinsicWidth(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: percentageController,
                  decoration: customInputDecoration.copyWith(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Icon(CupertinoIcons.percent, size: 16),
                    ),
                    suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: '100',
                  ),

                  // Restrict input to numeric, 3 digits.
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  maxLength: 3,
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    // A blank value will be stored as 0.
                    // Also removes leading 0s in the numeric text entry.
                    int valueAsInt = value.isNotEmpty ? int.parse(value) : 0;

                    // Blank values should still render as an empty string with hint text visible, and not as 0.
                    // Compute length to ensure that cursor remains at the end of the text when leading 0s are chopped.
                    int valueLength = value.isNotEmpty ? valueAsInt.toString().length : 0;
                    percentageController.value = percentageController.value.copyWith(
                      text: value.isNotEmpty ? valueAsInt.toString() : '',
                      selection: TextSelection.fromPosition(TextPosition(offset: valueLength)),
                    );

                    // Update varietal percentage and BLoC representation.
                    updateVarietalPercentage(valueAsInt, index);
                    submitVarietals();
                  },
                  validator: (String value) {
                    // Percentage is required only when the varietal name is provided.
                    if (varietalNames[index].isNotEmpty && value.isEmpty) {
                      return 'Required';
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
    final Color remainingPercentColor =
        _totalPercentage > 100 ? Theme.of(context).errorColor : Theme.of(context).colorScheme.onSurface;
    final bool grapeTextFieldsComplete =
        _totalPercentage == 100 && varietalNames.fold(true, (acc, v) => (acc && v.isNotEmpty));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: grapeFields,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Remaining: ${100 - _totalPercentage}%',
              style: Theme.of(context).textTheme.bodyText2.copyWith(color: remainingPercentColor),
            ),
            // Signal success when all fields are non-empty and percentages add to 100.
            if (grapeTextFieldsComplete)
              Expanded(
                child: Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.green),
              ),
            Expanded(child: Container()),
            TextButton.icon(
              style: Theme.of(context).outlinedButtonTheme.style,
              icon: Icon(
                CupertinoIcons.add,
                size: 14,
              ),
              label: Text('New grape'.toUpperCase()),
              onPressed: () {
                addGrapeFieldsWithDefaultValues(addDefaults: true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
