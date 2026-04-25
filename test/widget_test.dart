import 'package:flutter_test/flutter_test.dart';

import 'package:omnitrip/app.dart';

void main() {
  testWidgets('OmniTrip app boots to welcome screen', (tester) async {
    await tester.pumpWidget(const OmniTripApp(startLoggedIn: false));
    await tester.pumpAndSettle();

    expect(find.text('OmniTrip'), findsWidgets);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
