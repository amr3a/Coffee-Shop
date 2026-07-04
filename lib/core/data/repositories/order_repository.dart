import '../local_storage.dart';
import '../models/order_model.dart';

/// واجهة الطلبات.
///
/// بقية التطبيق يحفظ الطلب عبر هذه الواجهة فقط. لربط قاعدة بيانات/API لاحقاً:
/// اكتب كلاساً ينفّذ OrderRepository (مثلاً ApiOrderRepository) وغيّر السطر
/// الوحيد في service_locator.dart — بدون لمس واجهة المستخدم أو السلة.
abstract class OrderRepository {
  /// يحفظ/يرسل الطلب. يرجّع مسار الملف (أو مرجع) للعرض/التنقيح.
  Future<String> saveOrder(OrderModel order);

  /// يقرأ كل الطلبات المحفوظة.
  Future<List<OrderModel>> getOrders();
}

/// تطبيق الطلبات المعتمد على ملف نصي (orders.txt).
///
/// كل طلب = سطر JSON واحد يُضاف في نهاية الملف.
class TextFileOrderRepository implements OrderRepository {
  static const String fileName = 'orders.txt';

  @override
  Future<String> saveOrder(OrderModel order) async {
    await LocalStorage.appendLine(fileName, order.toLine());
    return LocalStorage.pathFor(fileName);
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final lines = await LocalStorage.readLines(fileName);
    final orders = <OrderModel>[];
    for (final line in lines) {
      try {
        orders.add(OrderModel.fromLine(line));
      } catch (_) {
        // تجاهل أي سطر تالف.
      }
    }
    return orders;
  }
}
