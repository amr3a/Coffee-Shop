import 'package:coffie_shop/core/constants/image_constiant.dart';
import 'package:coffie_shop/core/data/models/user_model.dart';
import 'package:coffie_shop/core/data/service_locator.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:coffie_shop/features/auth/views/register_view.dart';
import 'package:coffie_shop/features/auth/widgets/auth_text_field.dart';
import 'package:coffie_shop/features/home/views/main_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = "Please enter your email and password.");
      return;
    }
    if (!email.contains("@")) {
      setState(() => _error = "Please enter a valid email address.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    // المصادقة تتم عبر الـ repository (ملف نصي حالياً، قابل للتبديل لقاعدة بيانات).
    final UserModel? user = await ServiceLocator.auth.login(email, password);

    if (!mounted) return;
    setState(() => _loading = false);

    if (user == null) {
      setState(() => _error = "Incorrect email or password.");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Welcome back, ${user.name} \u2615"),
        backgroundColor: MyAppColor.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainView(currentUser: user)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== هيدر بصورة الترحيب وتدرّج داكن (نفس ستايل شاشة welcome) =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.asset(
                    MyAppImage.welcome,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  bottom: 28,
                  right: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome Back \u2615",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Sign in to order your favorite coffee.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ===== الفورم =====
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign In", style: MyTexeStyle.normalTitleText(size: 24)),
                  const SizedBox(height: 24),

                  AuthTextField(
                    controller: _emailController,
                    label: "Email",
                    hint: "you@coffee.com",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),

                  AuthTextField(
                    controller: _passwordController,
                    label: "Password",
                    hint: "Your password",
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: MyAppColor.subTitleText,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),

                  // رسالة الخطأ
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: _loading
                        ? Container(
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: MyAppColor.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        : MyGenrallButton(
                            name: "Sign In",
                            onPressed: _onLogin,
                          ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: MyTexeStyle.subTitleText(size: 14)),
                        GestureDetector(
                          onTap: _loading
                              ? null
                              : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterView()),
                                  ),
                          child: Text(
                            "Register",
                            style: MyTexeStyle.normalTitleText(
                                size: 14, color: MyAppColor.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // تلميح بحساب تجريبي حتى يجرّب المستخدم تسجيل الدخول مباشرة.
                  Center(
                    child: Text(
                      "Demo: sanaa@coffee.com / 123456",
                      style: MyTexeStyle.subTitleText(size: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
