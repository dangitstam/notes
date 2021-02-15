import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

class AlcoholByVolume extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17.0),
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
          IntrinsicWidth(
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
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

              // Restrict input to numeric, 3 digits.
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              maxLength: 4,
              style: Theme.of(context).textTheme.bodyText2,
              onChanged: (value) {
                context
                    .read<WineTastingCreateBloc>()
                    .add(AddAlcoholByVolumeEvent(alcoholByVolume: double.parse(value)));
              },
              validator: (value) {
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
