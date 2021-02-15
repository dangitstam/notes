import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/keys.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/components/info/grapes.dart';

class MockWineTastingCreateBloc extends MockBloc implements WineTastingCreateBloc {}

void main() {
  group(
    'Grapes',
    () {
      WineTastingCreateBloc wineTastingCreateBloc;

      setUp(() {
        wineTastingCreateBloc = MockWineTastingCreateBloc();
      });

      testWidgets('Add a new grape', (WidgetTester tester) async {
        // TODO: Test removing a grape.
        when(wineTastingCreateBloc.state).thenReturn(
          WineTastingCreateState(
            isWineTastingInserted: false,
            tasting: WineTasting(
              varietalNames: '',
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
        expect(state.grapeFields.length, 1);

        // Tap the `New grape` button.
        // TextButton.icon returns a type derived from TextButton...
        await tester.tap(
          find.ancestor(
            of: find.byIcon(CupertinoIcons.add),
            matching: find.byWidgetPredicate((widget) => widget is TextButton),
          ),
        );

        // Rebuild the widget after the state has changed.
        await tester.pump();

        expect(state.grapeFields.length, 2);
      });

      testWidgets(
        'GrapeTextFields varietals and percentages initialize from empty state properly',
        (WidgetTester tester) async {
          when(wineTastingCreateBloc.state).thenReturn(
            WineTastingCreateState(
              isWineTastingInserted: false,
              tasting: WineTasting(
                varietalNames: '',
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
                varietalNames: '[\"Grenache\",\"Mourvèdre\",\"Carignan\"]',
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

      testWidgets(
        'GrapeTextFields varietals and percentages can update BLoC',
        (WidgetTester tester) async {
          when(wineTastingCreateBloc.state).thenReturn(
            WineTastingCreateState(
              isWineTastingInserted: false,
              tasting: WineTasting(
                varietalNames: '',
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

          state.varietalNames = [
            'Sauvignon Blanc',
            'Marsanne',
          ];

          state.varietalPercentages = [
            60,
            40,
          ];

          state.submitVarietals();

          verify(
            wineTastingCreateBloc.add(
              AddWineVarietalNamesEvent(varietalNames: '[\"Sauvignon Blanc\",\"Marsanne\"]'),
            ),
          );
          verify(
            wineTastingCreateBloc.add(
              AddWineVarietalPercentagesEvent(varietalPercentages: '[60,40]'),
            ),
          );
        },
      );
    },
  );
}
