import 'package:ewaste_manager/screens/auth/login_screen.dart';
import 'package:ewaste_manager/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ewaste_manager/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify initial screen loads
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('E-Waste Manager'), findsOneWidget);
  });

  testWidgets('Navigation works', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const MyApp());

    // Verify we can navigate to other screens
    await tester.tap(find.text('About Us'));
    await tester.pumpAndSettle();
    expect(find.text('Our Mission'), findsOneWidget);
  });
}