import 'package:flutter_test/flutter_test.dart';

import 'package:omnitrip/app.dart';

void main() {
  testWidgets('OmniTrip app boots to welcome screen', (tester) async {
    await tester.pumpWidget(const OmniTripApp(startRoute: '/'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Travel Planner'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
