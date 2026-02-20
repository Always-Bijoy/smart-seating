import 'package:flutter_test/flutter_test.dart';
import 'package:smart_seating/main.dart';
import 'package:smart_seating/providers/locale_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(SmartSeatApp(
      localeProvider: LocaleProvider(),
    ));
    await tester.pump();
  });
}
