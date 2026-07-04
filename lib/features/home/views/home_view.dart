import 'package:coffie_shop/core/data/models/user_model.dart';
import 'package:coffie_shop/core/providers/cart_provider.dart';
import 'package:coffie_shop/features/home/widgets/My_home_banner.dart';
import 'package:coffie_shop/features/home/widgets/My_search_widget.dart';
import 'package:coffie_shop/features/home/widgets/home_backGround.dart';
import 'package:coffie_shop/features/home/widgets/lise_category_model.dart';
import 'package:coffie_shop/features/home/widgets/list_product_data.dart';
import 'package:coffie_shop/features/home/widgets/location_widget.dart';
import 'package:flutter/material.dart';

class HomwView extends StatelessWidget {
  final CartProvider cartProvider;
  final UserModel currentUser;
  const HomwView({
    super.key,
    required this.cartProvider,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const HomeBackGround(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                LocationWidget(userName: currentUser.name),
                const SizedBox(height: 24),
                const MySearchWidget(),
                const SizedBox(height: 24),
                const MyHomeBanner(),
                const SizedBox(height: 24),
                const MyListCategory(),
                const SizedBox(height: 16),
                ListProduct(cartProvider: cartProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
