import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mp5/main.dart' as app;
import 'package:mp5/views/weather_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.setMockInitialValues({});
  group('Weather App Integration Test', () {
    testWidgets('Add a city to favorites and verify',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      const String testCity = 'Paris';
      await tester.enterText(find.byType(TextField), testCity);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(WeatherDetailsPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text(testCity), findsOneWidget);
    });
  });
}
