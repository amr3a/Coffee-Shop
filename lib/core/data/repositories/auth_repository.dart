import '../local_storage.dart';
import '../models/user_model.dart';

/// واجهة المصادقة (تسجيل دخول/تسجيل جديد).
///
/// بقية التطبيق يتعامل مع هذه الواجهة فقط ولا يعرف من أين تأتي البيانات.
/// لربط قاعدة بيانات/API لاحقاً: اكتب كلاساً جديداً ينفّذ AuthRepository
/// (مثلاً ApiAuthRepository) وغيّر السطر الوحيد في service_locator.dart.
abstract class AuthRepository {
  /// يزرع حسابات افتراضية أول مرة فقط (إذا كان ملف المستخدمين فارغاً).
  Future<void> seedDefaultsIfEmpty();

  /// يحاول تسجيل الدخول. يرجّع المستخدم عند النجاح أو null عند فشل التطابق.
  Future<UserModel?> login(String email, String password);

  /// ينشئ حساباً جديداً. يرجّع false لو البريد مستخدم مسبقاً.
  Future<bool> register(UserModel user);

  /// هل يوجد حساب بهذا البريد؟
  Future<bool> emailExists(String email);
}

/// تطبيق المصادقة المعتمد على ملف نصي (users.txt).
///
/// كل مستخدم = سطر JSON واحد. القراءة/الكتابة تتم عبر LocalStorage.
class TextFileAuthRepository implements AuthRepository {
  static const String fileName = 'users.txt';

  /// حسابات تجريبية تُزرع أول تشغيل حتى يعمل تسجيل الدخول مباشرة.
  static final List<UserModel> _defaults = [
    UserModel(name: 'Sanaa', email: 'sanaa@coffee.com', password: '123456'),
    UserModel(name: 'Demo User', email: 'demo@coffee.com', password: '123456'),
  ];

  Future<List<UserModel>> _readAll() async {
    final lines = await LocalStorage.readLines(fileName);
    final users = <UserModel>[];
    for (final line in lines) {
      try {
        users.add(UserModel.fromLine(line));
      } catch (_) {
        // تجاهل أي سطر تالف بدل ما يكسر التطبيق.
      }
    }
    return users;
  }

  @override
  Future<void> seedDefaultsIfEmpty() async {
    final existing = await LocalStorage.readLines(fileName);
    if (existing.isNotEmpty) return;
    await LocalStorage.writeLines(
      fileName,
      _defaults.map((u) => u.toLine()).toList(),
    );
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _readAll();
    for (final user in users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<bool> emailExists(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _readAll();
    return users.any((u) => u.email.toLowerCase() == normalizedEmail);
  }

  @override
  Future<bool> register(UserModel user) async {
    if (await emailExists(user.email)) return false;
    final stored = UserModel(
      name: user.name.trim(),
      email: user.email.trim(),
      password: user.password,
    );
    await LocalStorage.appendLine(fileName, stored.toLine());
    return true;
  }
}
