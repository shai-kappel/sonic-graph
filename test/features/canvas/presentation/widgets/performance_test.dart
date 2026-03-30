import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/infinite_canvas.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/node_widget.dart';

void main() {
  testWidgets('InfiniteCanvas handles 100 nodes and interaction under load', (
    WidgetTester tester,
  ) async {
    final canvasBloc = CanvasBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: canvasBloc,
          child: const Scaffold(body: InfiniteCanvas()),
        ),
      ),
    );

    // Initial state
    canvasBloc.add(const CanvasInitialized());
    await tester.pumpAndSettle();

    // Verify 100 nodes are in the widget tree
    expect(find.byType(NodeWidget), findsNWidgets(100));

    // Verify some specific nodes are present
    expect(find.text('ARTIST 0'), findsOneWidget);
    expect(find.text('ARTIST 99'), findsOneWidget);

    // Simulate drag interaction
    final gesture = await tester.startGesture(const Offset(200, 200));
    await gesture.moveBy(const Offset(100, 100));
    await tester.pump();
    await gesture.moveBy(const Offset(-50, 150));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // Ensure no exceptions occurred and nodes are still there
    expect(find.byType(NodeWidget), findsNWidgets(100));
  });
}
