import 'package:flutter/material.dart';

class WineTypeToggleButtons extends StatefulWidget {
  @override
  _WineTypeToggleButtonsState createState() => _WineTypeToggleButtonsState();
}

class _WineTypeToggleButtonsState extends State<WineTypeToggleButtons> {
  String _wineType;
  String _sparklingType;
  String _result;

  List<String> types = [
    'Red',
    'White',
    'Rosé',
    'Skin-contact',
  ];
  List<bool> _typeSelection;

  List<String> bubbles = [
    'Yes',
    'No',
  ];
  List<bool> _bubblesSelection;

  @override
  void initState() {
    super.initState();

    setState(() {
      _wineType = '';
      _sparklingType = '';
      _result = '';
      _typeSelection = List<bool>.generate(types.length, (_) => false);
      _bubblesSelection = [false, true];
    });
  }

  void updateResult() {
    // TODO: Update bloc with this value.
    _result = '$_wineType $_sparklingType'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type'.toUpperCase(),
            style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double borderWidth = 2.0;
              final double borderOverflowOffsetWidth = borderWidth + (borderWidth / _typeSelection.length);
              return ToggleButtons(
                color: Theme.of(context).colorScheme.onSurface,
                fillColor: Theme.of(context).colorScheme.onSurface,
                textStyle: Theme.of(context).textTheme.caption,
                constraints: BoxConstraints.expand(
                  width: constraints.maxWidth / _typeSelection.length - borderOverflowOffsetWidth,
                ),
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Text('Red')),
                  Text('Rosé'),
                  Text('Skin Contact'),
                  Text('White'),
                ],
                isSelected: _typeSelection,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _typeSelection.length; i++) {
                      _typeSelection[i] = index == i;
                    }

                    _wineType = types[index];
                    updateResult();
                  });
                },

                // Borders
                borderColor: Theme.of(context).colorScheme.onSurface,
                borderWidth: borderWidth,
                selectedBorderColor: Theme.of(context).colorScheme.onSurface,
                selectedColor: Theme.of(context).colorScheme.background,
              );
            },
          ),

          /**
           * Bubbles.
           */
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Sparkling?'.toUpperCase(),
                    style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    color: Theme.of(context).colorScheme.onSurface,
                    fillColor: Theme.of(context).colorScheme.onSurface,
                    textStyle: Theme.of(context).textTheme.caption,

                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Yes'),
                      ),
                      Text('No'),
                    ],
                    isSelected: _bubblesSelection,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _bubblesSelection.length; i++) {
                          _bubblesSelection[i] = index == i;
                        }
                      });
                    },

                    // Borders
                    borderColor: Theme.of(context).colorScheme.onSurface,
                    borderWidth: 2,
                    selectedBorderColor: Theme.of(context).colorScheme.onSurface,
                    selectedColor: Theme.of(context).colorScheme.background,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: _bubblesSelection[0] ? 1.0 : 0.3,
                  duration: Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'What kind of bubbles?'.toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        enabled: _bubblesSelection[0],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pét-Nat',
                          counterText: '',
                        ),
                        onChanged: (value) {
                          _sparklingType = value;
                          updateResult();
                        },
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
