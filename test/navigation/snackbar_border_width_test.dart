import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(() => Get.reset());

  for (final withForm in [false, true]) {
    final content = withForm ? 'form' : 'message';
    for (final width in <double?>[null, 0, 2.5]) {
      testWidgets('Get.snackbar $content border width ${width ?? 'default'}',
          (tester) async {
        await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
        await tester.pump();

        final controller = Get.snackbar(
          'title',
          'message',
          borderColor: Colors.red,
          borderWidth: width,
          duration: null,
          animationDuration: Duration.zero,
          userInputForm: withForm
              ? Form(child: const Text('form content'))
              : null,
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        final borders = tester
            .widgetList<Container>(find.descendant(
              of: find.byType(GetSnackBar),
              matching: find.byType(Container),
            ))
            .map((container) => container.decoration)
            .whereType<BoxDecoration>()
            .map((decoration) => decoration.border)
            .whereType<Border>();
        expect(borders, hasLength(1));
        expect(borders.single, Border.all(color: Colors.red, width: width ?? 1));
        expect(controller.snackbar.borderWidth, width ?? 1);

        await controller.close(withAnimations: false);
        await tester.pumpAndSettle();
      });
    }
  }

  testWidgets('Get.snackbar preserves the default when borderWidth is omitted',
      (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await tester.pump();

    final controller = Get.snackbar(
      'title',
      'message',
      borderColor: Colors.red,
      duration: null,
      animationDuration: Duration.zero,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('message'), findsOneWidget);
    expect(controller.snackbar.borderWidth, 1);

    await controller.close(withAnimations: false);
    await tester.pumpAndSettle();
  });

  testWidgets('Get.snackbar without borderColor does not draw a border',
      (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    await tester.pump();

    final controller = Get.snackbar(
      'title',
      'message',
      duration: null,
      animationDuration: Duration.zero,
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('message'), findsOneWidget);
    final decorations = tester
        .widgetList<Container>(find.descendant(
          of: find.byType(GetSnackBar),
          matching: find.byType(Container),
        ))
        .map((container) => container.decoration)
        .whereType<BoxDecoration>();
    expect(decorations, isNotEmpty);
    expect(decorations.every((decoration) => decoration.border == null), isTrue);

    await controller.close(withAnimations: false);
    await tester.pumpAndSettle();
  });
}
