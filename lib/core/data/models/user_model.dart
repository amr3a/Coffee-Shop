import 'dart:convert';

/// نموذج المستخدم (account) المستخدم في تسجيل الدخول والتسجيل.
///
/// يُخزَّن كل مستخدم على شكل سطر JSON واحد داخل ملف users.txt.
/// استخدام JSON يجعل التحويل لاحقاً إلى صف في قاعدة بيانات أو body لطلب API
/// أمراً مباشراً (toMap هي نفسها التي سترسلها لقاعدة البيانات).
class UserModel {
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'password': password,
      };

  /// يحوّل المستخدم إلى سطر نصي واحد (JSON) لتخزينه في الملف.
  String toLine() => jsonEncode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        name: (map['name'] ?? '').toString(),
        email: (map['email'] ?? '').toString(),
        password: (map['password'] ?? '').toString(),
      );

  /// يقرأ مستخدماً من سطر نصي (JSON) قادم من الملف.
  factory UserModel.fromLine(String line) =>
      UserModel.fromMap(jsonDecode(line) as Map<String, dynamic>);
}
