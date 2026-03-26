import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_graph/main.dart';
import 'package:sonic_graph/features/canvas/presentation/pages/canvas_page.dart';
import 'package:sonic_graph/core/config/app_config.dart';

void main() {
  testWidgets('Smoke test: app launches and shows CanvasPage', (
    WidgetTester tester,
  ) async {
    // Initialize AppConfig for testing
    AppConfig.environment = Environment.dev;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const SonicGraphApp());
    await tester.pump(); // Allow BLoC initialization

    // Verify that the CanvasPage is present
    expect(find.byType(CanvasPage), findsOneWidget);

    // Verify initial zoom level is 100%
    expect(find.text('100%'), findsOneWidget);
  });
}
