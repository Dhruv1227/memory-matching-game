import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_matching_game/main.dart';

void main() {
  testWidgets('memory game launches from the start screen', (tester) async {
    await tester.pumpWidget(const MemoryMatchApp());

    expect(find.text('Memory Match'), findsOneWidget);
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);

    await tester.tap(find.text('Start Game'));
    await tester.pump();

    expect(find.text('Moves'), findsOneWidget);
    expect(find.text('Pairs'), findsOneWidget);
    expect(find.byIcon(Icons.collections_rounded), findsWidgets);
  });
}
