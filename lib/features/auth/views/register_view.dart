import 'package:coffie_shop/core/constants/image_constiant.dart';
import 'package:coffie_shop/core/data/models/user_model.dart';
import 'package:coffie_shop/core/data/service_locator.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:coffie_shop/features/auth/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = "Please fill in all fields.");
      return;
    }
    if (!email.contains("@")) {
      setState(() => _error = "Please enter a valid email address.");
      return;
    }
    if (password.length < 6) {
      setState(() => _error = "Password must be at least 6 characters.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    // الإنشاء يتم عبر الـ repository (يكتب سطراً جديداً في users.txt).
    final created = await ServiceLocator.auth.register(
      UserModel(name: name, email: email, password: password),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (!created) {
      setState(() => _error = "This email is already registered.");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Account created! Please sign in."),
        backgroundColor: MyAppColor.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context); // رجوع لصفحة تسجيل الدخول
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== هيدر بنفس ستايل صفحة الدخول =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  child: Image.asset(
                    MyAppImage.welcome,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 240,
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
                // زر الرجوع
                Positioned(
                  top: 0,
                  left: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8),
                            ],
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              size: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  bottom: 24,
                  right: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Join us and enjoy your coffee.",
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
                  AuthTextField(
                    controller: _nameController,
                    label: "Name",
                    hint: "Your name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 18),

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
                    hint: "At least 6 characters",
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
                            name: "Create Account",
                            onPressed: _onRegister,
                          ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: MyTexeStyle.subTitleText(size: 14)),
                        GestureDetector(
                          onTap:
                              _loading ? null : () => Navigator.pop(context),
                          child: Text(
                            "Sign In",
                            style: MyTexeStyle.normalTitleText(
                                size: 14, color: MyAppColor.primaryColor),
                          ),
                        ),
                      ],
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
