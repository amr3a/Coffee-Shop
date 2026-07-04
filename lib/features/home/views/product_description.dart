import 'package:coffie_shop/core/models/proudct_model.dart';
import 'package:coffie_shop/core/providers/cart_provider.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProductDescription extends StatefulWidget {
  final ProductModel products;
  final CartProvider cartProvider;
  const ProductDescription({super.key, required this.products, required this.cartProvider});

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String selectedSize = "M";
  bool isFavorite = false;
  int quantity = 1;

  Map<String, double> get sizeMultiplier => {"S": 0.85, "M": 1.0, "L": 1.2};

  double get totalPrice => widget.products.price * (sizeMultiplier[selectedSize] ?? 1.0) * quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with back button overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    widget.products.image,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Top bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _circleButton(
                            icon: Icons.arrow_back_ios_new,
                            onTap: () => Navigator.pop(context),
                          ),
                          Text("Detail", style: MyTexeStyle.normalTitleText(size: 18, color: Colors.white)),
                          _circleButton(
                            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                            iconColor: isFavorite ? Colors.red : Colors.black,
                            onTap: () => setState(() => isFavorite = !isFavorite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Rating badge on image
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text("${widget.products.rate}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("  (5,725)", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.products.name, style: MyTexeStyle.normalTitleText(size: 26)),
                            const SizedBox(height: 4),
                            Text(widget.products.type, style: MyTexeStyle.subTitleText(size: 14)),
                          ],
                        ),
                      ),
                      // Icons
                      Row(
                        children: [
                          _iconChip(Icons.delivery_dining),
                          const SizedBox(width: 8),
                          _iconChip(Icons.coffee),
                          const SizedBox(width: 8),
                          _iconChip(Icons.local_cafe),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Description
                  Text("Description", style: MyTexeStyle.normalTitleText(size: 18)),
                  const SizedBox(height: 10),
                  Text(widget.products.description,
                      style: MyTexeStyle.subTitleText(size: 14),
                      ),

                  const SizedBox(height: 24),

                  // Size
                  Text("Size", style: MyTexeStyle.normalTitleText(size: 18)),
                  const SizedBox(height: 12),
                  Row(
                    children: ["S", "M", "L"].map((s) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ButtonSizeCoffeeWidget(
                          size: s,
                          isSelected: selectedSize == s,
                          onTap: () => setState(() => selectedSize = s),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Quantity", style: MyTexeStyle.normalTitleText(size: 18)),
                      Row(
                        children: [
                          _qtyButton(Icons.remove, () {
                            if (quantity > 1) setState(() => quantity--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("$quantity", style: MyTexeStyle.normalTitleText(size: 18)),
                          ),
                          _qtyButton(Icons.add, () => setState(() => quantity++)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Price + Buy button
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: MyTexeStyle.subTitleText(size: 13)),
                          const SizedBox(height: 4),
                          Text("\$ ${totalPrice.toStringAsFixed(2)}",
                              style: MyTexeStyle.normalTitleText(size: 22, color: MyAppColor.primaryColor)),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: MyGenrallButton(
                            name: "Add to Cart",
                            onPressed: () {
                              for (int i = 0; i < quantity; i++) {
                                widget.cartProvider.addItem(widget.products);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${widget.products.name} added to cart ☕"),
                                  backgroundColor: MyAppColor.primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
        ),
        child: Icon(icon, size: 18, color: iconColor ?? Colors.black),
      ),
    );
  }

  Widget _iconChip(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MyAppColor.dividerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: MyAppColor.primaryColor, size: 20),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: MyAppColor.dividerColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: MyAppColor.primaryColor),
      ),
    );
  }
}
