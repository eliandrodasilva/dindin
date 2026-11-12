import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dindin/pages/home_page.dart';
import 'package:dindin/state/app_state.dart';
import 'package:dindin/state/app_state_scope.dart';
import 'package:dindin/theme/app_theme.dart';

void main() {
  testWidgets('Capture parent dashboard screenshot', (tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final dir = Directory('screenshots');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final parentState = AppState();
    await tester.pumpWidget(
      AppStateScope(
        notifier: parentState,
        child: MaterialApp(
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          home: const RepaintBoundary(
            key: ValueKey('capture_parent'),
            child: HomePage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final boundaryParent = tester.renderObject(
      find.byKey(const ValueKey('capture_parent')),
    ) as RenderRepaintBoundary;

    await tester.runAsync(() async {
      final imgParent = await boundaryParent.toImage(pixelRatio: 2.0);
      final bytesParent = (await imgParent.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
      File('screenshots/parent_dashboard.png').writeAsBytesSync(bytesParent);
    });
  });

  testWidgets('Capture child dashboard screenshot', (tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final dir = Directory('screenshots');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final childState = AppState();
    childState.alternarUsuario('child-2'); // Sofia
    await tester.pumpWidget(
      AppStateScope(
        notifier: childState,
        child: MaterialApp(
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          home: const RepaintBoundary(
            key: ValueKey('capture_child'),
            child: HomePage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final boundaryChild = tester.renderObject(
      find.byKey(const ValueKey('capture_child')),
    ) as RenderRepaintBoundary;

    await tester.runAsync(() async {
      final imgChild = await boundaryChild.toImage(pixelRatio: 2.0);
      final bytesChild = (await imgChild.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
      File('screenshots/child_dashboard.png').writeAsBytesSync(bytesChild);
    });
  });
}
