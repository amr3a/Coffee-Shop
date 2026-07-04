import 'package:coffie_shop/core/constants/image_constiant.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:coffie_shop/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';

class WelocmeViewPage extends StatelessWidget {
  const WelocmeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  child: Image.asset(MyAppImage.welcome, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(color: Colors.black),
              ),
            ],
          ),

          // Gradient overlay + content
          Column(
            children: [
              const Spacer(flex: 5),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Fall in Love with\nCoffee in Blissful Delight!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Welcome to our cozy coffee corner, where every cup is a delightful experience.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: MyAppColor.subTitleText,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: MyGenrallButton(
                          name: "Get Started",
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginView()),
                              (_) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
