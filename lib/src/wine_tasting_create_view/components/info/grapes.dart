import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/keys.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:provider/provider.dart';

/// Grapes section allowing users to specify the varietals in their wine.
class Grapes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Grapes'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          GrapeTextFields(),
        ],
      ),
    );
  }
}

/// Custom widget with a pair of text forms to specify a varietal and it's proportion as a percentage.
class GrapeTextFields extends StatefulWidget {
  GrapeTextFields() : super(key: WidgetKeys.grapeTextFields);

  @override
  GrapeTextFieldsState createState() => GrapeTextFieldsState();
}

class GrapeTextFieldsState extends State<GrapeTextFields> {
  // Invariant: Elements of `varietalNames` and `varietalPercentages` correspond with each other,
  // such that at index i, the wine is varietalPercentages[i] of grape varietalNames[i].
  List<String> varietalNames = <String>[];
  List<int> varietalPercentages = <int>[];

  // Each widget represents a pair of form fields: grape name and percentage.
  List<Widget> grapeFields = <Widget>[];

  // Invariant: This value represents the number of varietals specified by the user.
  int _numVarietals = 0;

  // Invariant: This represents the sum of percentages for all specified varietals.
  int _totalPercentage = 0;

  /// Override [didChangeDependencies] instead of [initState] so that theme
  /// changes can be picked up for dependent widgets.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WineTasting currentTasting = context.read<WineTastingCreateBloc>().state.tasting;
    String varietalNamesFromBloc = currentTasting.varietalNames;
    String varietalPercentagesFromBloc = currentTasting.varietalPercentages;

    if (varietalNamesFromBloc.isNotEmpty && varietalPercentagesFromBloc.isNotEmpty) {
      varietalNames = json.decode(varietalNamesFromBloc).cast<String>();
      varietalPercentages = json.decode(varietalPercentagesFromBloc).cast<int>();
      for (var _ in varietalNames) {
        _addGrapeFields(addDefaults: false);
      }
    } else {
      _addGrapeFields(addDefaults: true);
    }
  }

  /// Given the currently specified varietals and their proportions, updates the BLoC.
  void submitVarietals() {
    // TODO: Would be more efficient to call this function only once (at time of closing info screen).
    String varietalNamesJson = json.encode(varietalNames);
    String varietalPercentagesJson = json.encode(varietalPercentages);
    context.read<WineTastingCreateBloc>().add(AddWineVarietalNamesEvent(varietalNames: varietalNamesJson));
    context
        .read<WineTastingCreateBloc>()
        .add(AddWineVarietalPercentagesEvent(varietalPercentages: varietalPercentagesJson));
  }

  int _getVarietalPercentageSum() {
    return varietalPercentages.fold(0, (acc, v) => acc + v);
  }

  void _updateTotalPercentage() {
    _totalPercentage = _getVarietalPercentageSum();
  }

  void _updateVarietalPercentage(int value, int index) {
    varietalPercentages[index] = value;
    _updateTotalPercentage();
  }

  void _addGrapeFields({bool addDefaults = false}) {
    setState(() {
      if (addDefaults) {
        varietalNames.add('');

        // Each subsequent grape will compute and autofill the remaining percentage.
        int remainingPercent = max(100 - _getVarietalPercentageSum(), 0);
        varietalPercentages.add(remainingPercent);
      }

      // Add fields for the new grape.
      grapeFields.add(_createNewGrapeFields(context, _numVarietals));

      // Update varietal metadata.
      _numVarietals++;
      _updateTotalPercentage();
    });
  }

  Widget _createNewGrapeFields(BuildContext context, int index) {
    final TextEditingController varietalController = TextEditingController(
      text: varietalNames[index].toString(),
    );

    final TextEditingController percentageController = TextEditingController(
      text: varietalPercentages[index].toString(),
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter grape name',
                    labelText: 'Varietal Name',
                    counterText: '',
                  ),
                  onChanged: (value) {
                    varietalNames[index] = value;

                    // Update BLoC representation.
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Icon(CupertinoIcons.percent, size: 16),
                    ),
                    suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: '100',
                    labelText: 'Percentage',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: '',
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
                    _updateVarietalPercentage(valueAsInt, index);
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
    // Display an error color when percentage exceeds 100.
    final Color remainingPercentColor =
        _totalPercentage > 100 ? Theme.of(context).errorColor : Theme.of(context).colorScheme.onSurface;

    // Signal success with a checkmark when all fields are non-empty and percentages add to 100.
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
            if (grapeTextFieldsComplete)
              Expanded(
                child: Icon(CupertinoIcons.checkmark_circle_fill, color: Colors.green),
              ),
            // Allows Remaining and the checkmark to be left-aligned while also spacing out from 'New grape'.
            Expanded(child: Container()),
            TextButton.icon(
              style: Theme.of(context).outlinedButtonTheme.style,
              icon: Icon(CupertinoIcons.add, size: 14),
              label: Text('New grape'.toUpperCase()),
              onPressed: () {
                _addGrapeFields(addDefaults: true);
              },
            ),
          ],
        ),
      ],
    );
  }
}
