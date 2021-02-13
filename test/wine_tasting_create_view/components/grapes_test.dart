import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/keys.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/components/grapes.dart';

class MockWineTastingCreateBloc extends MockBloc implements WineTastingCreateBloc {}

void main() {
  group(
    'Grapes',
    () {
      WineTastingCreateBloc wineTastingCreateBloc;

      setUp(() {
        wineTastingCreateBloc = MockWineTastingCreateBloc();
      });

      testWidgets(
        'GrapeTextFields varietals and percentages initialize from empty state properly',
        (WidgetTester tester) async {
          when(wineTastingCreateBloc.state).thenReturn(
            WineTastingCreateState(
              isWineTastingInserted: false,
              tasting: WineTasting(
                varietals: '',
                varietalPercentages: '',
              ),
            ),
          );

          var grapeFields = GrapeTextFields();
          await tester.pumpWidget(
            BlocProvider.value(
              value: wineTastingCreateBloc,
              child: MaterialApp(
                home: Scaffold(
                  body: grapeFields,
                ),
              ),
            ),
          );

          GrapeTextFieldsState state = tester.state(
            find.byKey(
              Key('__grapeTextFields__'),
            ),
          );

          //
          expect(state.varietalNames, ['']);
          expect(state.varietalPercentages, [100]);
        },
      );

      testWidgets(
        'GrapeTextFields varietals and percentages initialize from non-empty state properly',
        (WidgetTester tester) async {
          when(wineTastingCreateBloc.state).thenReturn(
            WineTastingCreateState(
              isWineTastingInserted: false,
              tasting: WineTasting(
                varietals: '[\"Grenache\",\"Mourvèdre\",\"Carignan\"]',
                varietalPercentages: '[80,15,5]',
              ),
            ),
          );

          var grapeFields = GrapeTextFields();
          await tester.pumpWidget(
            BlocProvider.value(
              value: wineTastingCreateBloc,
              child: MaterialApp(
                home: Scaffold(
                  body: grapeFields,
                ),
              ),
            ),
          );

          GrapeTextFieldsState state = tester.state(
            find.byKey(WidgetKeys.grapeTextFields),
          );

          expect(state.varietalNames, ['Grenache', 'Mourvèdre', 'Carignan']);
          expect(state.varietalPercentages, [80, 15, 5]);
        },
      );
    },
  );
}
