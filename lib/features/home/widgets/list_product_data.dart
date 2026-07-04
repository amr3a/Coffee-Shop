import 'package:coffie_shop/core/constants/image_constiant.dart';
import 'package:coffie_shop/core/models/proudct_model.dart';
import 'package:coffie_shop/core/providers/cart_provider.dart';
import 'package:coffie_shop/core/shared/buttons.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:coffie_shop/features/home/views/product_description.dart';
import 'package:flutter/material.dart';

class ListProduct extends StatelessWidget {
  final CartProvider cartProvider;
  ListProduct({super.key, required this.cartProvider});

  final List<ProductModel> products = [
    ProductModel(id: 1, name: "Caffe Mocha", image: MyAppImage.product01,
        description: "A rich blend of espresso, steamed milk, and chocolate syrup topped with whipped cream. Perfect for chocolate and coffee lovers.",
        type: "Deep Foam", price: 4.53, rate: 4.8),
    ProductModel(id: 2, name: "Flat White", image: MyAppImage.product02,
        description: "A velvety smooth espresso with microfoam milk. Strong yet creamy — a favorite for those who love bold coffee.",
        type: "Espresso", price: 3.90, rate: 4.6),
    ProductModel(id: 3, name: "Cappuccino", image: MyAppImage.product03,
        description: "Classic Italian coffee with equal parts espresso, steamed milk, and thick foam. A timeless coffeehouse staple.",
        type: "Milk Foam", price: 4.20, rate: 4.7),
    ProductModel(id: 4, name: "Americano", image: MyAppImage.product04,
        description: "Espresso shots diluted with hot water giving a light, clean coffee taste. Simple, bold, and satisfying.",
        type: "Black Coffee", price: 3.50, rate: 4.5),
    ProductModel(id: 5, name: "Vanilla Latte", image: MyAppImage.product05,
        description: "Smooth espresso with creamy steamed milk and a hint of sweet vanilla. Comforting and delicious in every sip.",
        type: "Sweet Latte", price: 4.75, rate: 4.9),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 12,
          childAspectRatio: 1 / 1.7,
          crossAxisSpacing: 15,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return ProductWidget(product: products[index], cartProvider: cartProvider);
        },
      ),
    );
  }
}

class ProductWidget extends StatefulWidget {
  final ProductModel product;
  final CartProvider cartProvider;
  const ProductWidget({super.key, required this.product, required this.cartProvider});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDescription(products: widget.product, cartProvider: widget.cartProvider),
                ),
              );
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(widget.product.image, width: double.infinity, fit: BoxFit.cover),
                      // Rating badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.orange, size: 12),
                              const SizedBox(width: 3),
                              Text("${widget.product.rate}",
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => isFavorite = !isFavorite),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name,
                          style: MyTexeStyle.normalTitleText(size: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(widget.product.type, style: MyTexeStyle.subTitleText(size: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 6, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("\$ ${widget.product.price}", style: MyTexeStyle.normalTitleText(size: 14)),
                GestureDetector(
                  onTap: () {
                    widget.cartProvider.addItem(widget.product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${widget.product.name} added to cart ☕"),
                        backgroundColor: MyAppColor.primaryColor,
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: MyAppColor.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
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
