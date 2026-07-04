import 'dart:convert';

/// عنصر واحد داخل الطلب (نوع القهوة + الكمية + السعر).
class OrderItem {
  final int productId;
  final String name;
  final String type;
  final double unitPrice;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.type,
    required this.unitPrice,
    required this.quantity,
  });

  double get lineTotal => unitPrice * quantity;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'name': name,
        'type': type,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
        productId: (map['productId'] ?? 0) as int,
        name: (map['name'] ?? '').toString(),
        type: (map['type'] ?? '').toString(),
        unitPrice: (map['unitPrice'] ?? 0).toDouble(),
        quantity: (map['quantity'] ?? 1) as int,
      );
}

/// نموذج الطلب (order) الذي يُرسل/يُحفظ عند الضغط على "Order Now".
///
/// يُخزَّن كل طلب على شكل سطر JSON واحد داخل ملف orders.txt.
/// هذه الصيغة (JSON Lines) جاهزة للاستيراد مباشرة في قاعدة بيانات أو
/// إرسالها كـ payload لـ API لاحقاً بدون تغيير الكود الذي يبنيها.
class OrderModel {
  final String id;
  final String customerName;
  final String customerEmail;
  final List<OrderItem> items;
  final double total;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'items': items.map((e) => e.toMap()).toList(),
        'total': total,
        'createdAt': createdAt.toIso8601String(),
      };

  /// يحوّل الطلب إلى سطر نصي واحد (JSON) لتخزينه في الملف.
  String toLine() => jsonEncode(toMap());

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: (map['id'] ?? '').toString(),
        customerName: (map['customerName'] ?? '').toString(),
        customerEmail: (map['customerEmail'] ?? '').toString(),
        items: ((map['items'] ?? const []) as List)
            .map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
            .toList(),
        total: (map['total'] ?? 0).toDouble(),
        createdAt:
            DateTime.tryParse((map['createdAt'] ?? '').toString()) ??
                DateTime.now(),
      );

  /// يقرأ طلباً من سطر نصي (JSON) قادم من الملف.
  factory OrderModel.fromLine(String line) =>
      OrderModel.fromMap(jsonDecode(line) as Map<String, dynamic>);
}
