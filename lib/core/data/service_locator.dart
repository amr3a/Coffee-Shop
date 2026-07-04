import 'repositories/auth_repository.dart';
import 'repositories/order_repository.dart';

/// نقطة التبديل الوحيدة (Dependency Injection بسيط).
///
/// كل التطبيق يأخذ المصادقة والطلبات من هنا. اليوم التطبيق يستخدم ملفات نصية.
/// لاحقاً، عند ربط قاعدة بيانات أو API، غيّر هذين السطرين فقط إلى التطبيق
/// الجديد (مثلاً ApiAuthRepository / SqlOrderRepository) وكل شيء يكمل
/// شغّال بدون تغيير في الشاشات.
///
///   static final AuthRepository auth = ApiAuthRepository();
///   static final OrderRepository orders = ApiOrderRepository();
class ServiceLocator {
  ServiceLocator._();

  static final AuthRepository auth = TextFileAuthRepository();
  static final OrderRepository orders = TextFileOrderRepository();
}
