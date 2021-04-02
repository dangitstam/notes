import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

class WineTypeToggleButtons extends StatefulWidget {
  @override
  _WineTypeToggleButtonsState createState() => _WineTypeToggleButtonsState();
}

class _WineTypeToggleButtonsState extends State<WineTypeToggleButtons> {
  String _wineType = '';
  String _sparklingType = '';

  List<String> _types = [
    'Red',
    'Rosé',
    'Skin Contact',
    'White',
  ];
  List<bool> _typeSelection = List<bool>.generate(4, (_) => false);

  List<String> bubbles = [
    'Yes',
    'No',
  ];
  List<bool> _bubblesSelection = [false, true];

  TextEditingController _bubblesTextEditingController;

  @override
  void initState() {
    super.initState();

    setState(() {
      _wineType = context.read<WineTastingCreateBloc>().state.tasting.wineType;
      if (_wineType.isNotEmpty) {
        int index = _types.indexOf(_wineType);
        if (index >= 0) {
          _typeSelection[index] = true;
        }
      }

      _sparklingType = context.read<WineTastingCreateBloc>().state.tasting.bubbles;
      if (_sparklingType.isNotEmpty) {
        _bubblesSelection = [true, false];
      }

      _bubblesTextEditingController = TextEditingController(
        text: _sparklingType,
      );
    });
  }

  void submitWineType() {
    context.read<WineTastingCreateBloc>().add(AddWineTypeEvent(wineType: _wineType));
  }

  void submitBubbles() {
    context.read<WineTastingCreateBloc>().add(AddBubblesEvent(bubbles: _sparklingType));
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
                children: _types.map(
                  (String type) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(type),
                    );
                  },
                ).toList(),
                isSelected: _typeSelection,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _typeSelection.length; i++) {
                      _typeSelection[i] = index == i;
                    }

                    _wineType = _types[index];
                    submitWineType();
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

                        // Clear value if no is selected.
                        if (index == 1) {
                          _sparklingType = '';
                          submitBubbles();
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
                  // Fade the widget to 30% opacity when sparkling is on 'No'.
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
                        controller: _bubblesTextEditingController,
                        enabled: _bubblesSelection[0],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pét-Nat',
                          counterText: '',
                        ),
                        onChanged: (value) {
                          _sparklingType = value;
                          submitBubbles();
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
