import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sortapp/main.dart';

void main() {
  testWidgets('renders the sorting visualizer', (WidgetTester tester) async {
    await tester.pumpWidget(const SortingApp());

    expect(find.text('Sorting Visualizer'), findsWidgets);
    expect(find.byIcon(Icons.auto_graph), findsOneWidget);
  });
}
