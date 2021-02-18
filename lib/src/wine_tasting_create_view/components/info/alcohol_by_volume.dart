import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

class AlcoholByVolume extends StatefulWidget {
  @override
  _AlcoholByVolumeState createState() => _AlcoholByVolumeState();
}

class _AlcoholByVolumeState extends State<AlcoholByVolume> {
  TextEditingController _vintageController;
  TextEditingController _alcoholByVolumeController;

  @override
  void initState() {
    super.initState();

    int initialVintage = context.read<WineTastingCreateBloc>().state.tasting.vintage;
    _vintageController = TextEditingController(
      text: initialVintage > 0 ? '$initialVintage' : null,
    );

    double initialAlcoholByVolume = context.read<WineTastingCreateBloc>().state.tasting.alcoholByVolume;
    _alcoholByVolumeController = TextEditingController(
      text: initialAlcoholByVolume > 0.0 ? '$initialAlcoholByVolume' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Vintage'.toUpperCase(),
                      style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: _vintageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '2019',
                    labelText: 'Year',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: '',
                  ),

                  // Restrict input to numeric, room for 3 digits and a decimal.
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    // Default to -1.0 to signal alcohol as unspecified.
                    final int parsedYear = int.tryParse(value);
                    if (parsedYear != null) {
                      context.read<WineTastingCreateBloc>().add(AddVintageEvent(vintage: parsedYear));
                    } else {
                      context.read<WineTastingCreateBloc>().add(AddVintageEvent(vintage: -1));
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Alcohol By Volume'.toUpperCase(),
                      style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  controller: _alcoholByVolumeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Icon(CupertinoIcons.percent, size: 16),
                    ),
                    suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: '12.5',
                    labelText: 'Percentage',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: '',
                  ),

                  // Restrict input to numeric, room for 3 digits and a decimal.
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  maxLength: 4,
                  style: Theme.of(context).textTheme.bodyText2,
                  onChanged: (value) {
                    // Default to -1.0 to signal alcohol as unspecified.
                    final double parsedValue = double.tryParse(value);
                    if (parsedValue != null) {
                      context.read<WineTastingCreateBloc>().add(AddAlcoholByVolumeEvent(alcoholByVolume: parsedValue));
                    } else {
                      context.read<WineTastingCreateBloc>().add(AddAlcoholByVolumeEvent(alcoholByVolume: -1.0));
                    }
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      final double parsedValue = double.tryParse(value);
                      if (parsedValue == null) {
                        return 'Not a %!';
                      }
                      if (parsedValue > 100) {
                        return 'Too high!';
                      }
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
