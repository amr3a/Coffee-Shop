import 'package:coffie_shop/core/data/models/order_model.dart';
import 'package:coffie_shop/core/data/models/user_model.dart';
import 'package:coffie_shop/core/data/service_locator.dart';
import 'package:coffie_shop/core/providers/cart_provider.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  final CartProvider cartProvider;
  final UserModel currentUser;
  const CartView({
    super.key,
    required this.cartProvider,
    required this.currentUser,
  });

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  bool _placingOrder = false;

  /// يبني نموذج الطلب من عناصر السلة (مع تجميع الكميات حسب المنتج)
  /// ثم يحفظه عبر الـ repository (ملف orders.txt حالياً).
  Future<void> _placeOrder() async {
    final items = widget.cartProvider.items;
    if (items.isEmpty || _placingOrder) return;

    // تجميع العناصر المتكررة في سطر واحد مع كمية.
    final Map<int, OrderItem> grouped = {};
    for (final p in items) {
      final existing = grouped[p.id];
      if (existing == null) {
        grouped[p.id] = OrderItem(
          productId: p.id,
          name: p.name,
          type: p.type,
          unitPrice: p.price,
          quantity: 1,
        );
      } else {
        grouped[p.id] = OrderItem(
          productId: existing.productId,
          name: existing.name,
          type: existing.type,
          unitPrice: existing.unitPrice,
          quantity: existing.quantity + 1,
        );
      }
    }

    final now = DateTime.now();
    final order = OrderModel(
      id: now.millisecondsSinceEpoch.toString(),
      customerName: widget.currentUser.name,
      customerEmail: widget.currentUser.email,
      items: grouped.values.toList(),
      total: widget.cartProvider.total,
      createdAt: now,
    );

    setState(() => _placingOrder = true);

    String? savedPath;
    String? errorMsg;
    try {
      // هنا تُرسل بيانات الطلب إلى الملف النصي (بديل قاعدة البيانات).
      savedPath = await ServiceLocator.orders.saveOrder(order);
    } catch (e) {
      errorMsg = e.toString();
    }

    if (!mounted) return;
    setState(() => _placingOrder = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(errorMsg == null ? "Order Placed! \u2615" : "Something went wrong"),
        content: Text(
          errorMsg == null
              ? "Your coffee is on the way. Enjoy your cup!\n\nSaved to:\n$savedPath"
              : "Could not save the order:\n$errorMsg",
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (errorMsg == null) {
                setState(() => widget.cartProvider.clear());
              }
            },
            child: Text("OK", style: TextStyle(color: MyAppColor.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cartProvider.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My Cart", style: MyTexeStyle.normalTitleText(size: 20)),
        centerTitle: true,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() => widget.cartProvider.clear());
              },
              child: Text("Clear", style: TextStyle(color: MyAppColor.primaryColor)),
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: MyAppColor.subTitleText),
                  const SizedBox(height: 16),
                  Text("Your cart is empty", style: MyTexeStyle.subTitleText(size: 18)),
                  const SizedBox(height: 8),
                  Text("Add some coffee to get started!", style: MyTexeStyle.subTitleText(size: 14)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(item.image, width: 80, height: 80, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: MyTexeStyle.normalTitleText()),
                                  const SizedBox(height: 4),
                                  Text(item.type, style: MyTexeStyle.subTitleText(size: 13)),
                                  const SizedBox(height: 8),
                                  Text("\$ ${item.price}",
                                      style: MyTexeStyle.normalTitleText(color: MyAppColor.primaryColor)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() => widget.cartProvider.removeItem(index));
                              },
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Payment", style: MyTexeStyle.subTitleText(size: 16)),
                          Text("\$ ${widget.cartProvider.total.toStringAsFixed(2)}",
                              style: MyTexeStyle.normalTitleText(size: 20, color: MyAppColor.primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: _placingOrder
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
                                name: "Order Now",
                                onPressed: _placeOrder,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
