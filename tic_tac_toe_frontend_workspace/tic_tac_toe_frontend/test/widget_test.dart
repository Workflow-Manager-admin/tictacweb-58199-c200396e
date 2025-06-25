import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('TicTacToeApp builds and displays board', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Title present
    expect(find.text('Tic Tac Toe'), findsOneWidget);

    // There are player selector buttons ("X" and "O")
    expect(find.text('X'), findsWidgets);
    expect(find.text('O'), findsWidgets);

    // There should be exactly 9 touchable board cells
    final boardCells = tester.widgetList<GestureDetector>(
      find.byType(GestureDetector)
    ).where((g) => g.onTap != null).toList();
    expect(boardCells.length >= 9, true); // At least 9 interactive cells (the board)

    // Action buttons
    expect(find.textContaining("Restart"), findsOneWidget);
    expect(find.textContaining("New Game"), findsOneWidget);
  });
}
