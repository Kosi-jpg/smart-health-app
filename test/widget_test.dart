
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_app/main.dart';

void main() {
  testWidgets('Smart Health App opens successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Smart Health App'), findsOneWidget);
  });
}
