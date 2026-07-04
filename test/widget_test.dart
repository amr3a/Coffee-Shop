// اختبار دخان بسيط: يتأكد أن التطبيق يبني شاشة الترحيب بدون أخطاء.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffie_shop/main.dart';

void main() {
  testWidgets('App builds welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // زر البداية موجود في شاشة الترحيب.
    expect(find.text('Get Started'), findsOneWidget);
  });
}
