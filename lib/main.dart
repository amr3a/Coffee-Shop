import 'package:coffie_shop/core/data/service_locator.dart';
import 'package:coffie_shop/features/home/views/welcome_view_page.dart';
import 'package:flutter/material.dart';

void main() async {
  // لازم لتهيئة الوصول للملفات قبل runApp.
  WidgetsFlutterBinding.ensureInitialized();

  // يزرع حسابات تجريبية في users.txt أول تشغيل فقط (حتى يعمل الدخول مباشرة).
  await ServiceLocator.auth.seedDefaultsIfEmpty();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sora",
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffC67C4E)),
      ),
      debugShowCheckedModeBanner: false,
      home: const WelocmeViewPage(),
    );
  }
}
