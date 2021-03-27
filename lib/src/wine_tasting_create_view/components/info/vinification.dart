import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

/// Vinification section allows classifying the wine as being any of the following:
/// Biodynamic, Organic Farming, Unfined & Unfiltered, Wild Yeast, No Added S02, and Ethically Made.
class Vinification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var wineTastingState = context.watch<WineTastingCreateBloc>().state.tasting;

    /// Styled checkbox list tile for convenience.
    Widget VinificationCheckboxListTile({String label, bool value, Function(bool) onChanged}) {
      return CheckboxListTile(
        activeColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.all(0),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        title: Text(label, style: Theme.of(context).textTheme.bodyText2),
        value: value,
        onChanged: (bool value) {
          onChanged(value);
        },
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vinification'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VinificationCheckboxListTile(
                      label: 'Biodynamic',
                      value: wineTastingState.isBiodynamic,
                      onChanged: (bool value) {
                        context.read<WineTastingCreateBloc>().add(SetIsBiodynamicEvent(isBiodynamic: value));
                      },
                    ),
                    VinificationCheckboxListTile(
                      label: 'Organic Farming',
                      value: wineTastingState.isOrganicFarming,
                      onChanged: (bool value) {
                        context.read<WineTastingCreateBloc>().add(SetIsOrganicFarmingEvent(isOrganicFarming: value));
                      },
                    ),
                    VinificationCheckboxListTile(
                      label: 'Unfined & Unfiltered',
                      value: wineTastingState.isUnfinedUnfiltered,
                      onChanged: (bool value) {
                        context
                            .read<WineTastingCreateBloc>()
                            .add(SetIsUnfinedUnfilteredEvent(isUnfinedUnfiltered: value));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    VinificationCheckboxListTile(
                      label: 'Wild Yeast',
                      value: wineTastingState.isWildYeast,
                      onChanged: (bool value) {
                        context.read<WineTastingCreateBloc>().add(SetIsWildYeastEvent(isWildYeast: value));
                      },
                    ),
                    VinificationCheckboxListTile(
                      label: 'No Added S02',
                      value: wineTastingState.isNoAddedSulfites,
                      onChanged: (bool value) {
                        context.read<WineTastingCreateBloc>().add(SetIsNoAddedSulfitesEvent(isNoAddedSulfites: value));
                      },
                    ),
                    VinificationCheckboxListTile(
                      label: 'Ethically Made',
                      value: wineTastingState.isEthicallyMade,
                      onChanged: (bool value) {
                        context.read<WineTastingCreateBloc>().add(SetIsEthicallyMadeEvent(isEthicallyMade: value));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
