import 'package:coffie_shop/core/data/models/user_model.dart';
import 'package:coffie_shop/core/providers/cart_provider.dart';
import 'package:coffie_shop/core/theme/app_theme.dart';
import 'package:coffie_shop/features/cart/views/cart_view.dart';
import 'package:coffie_shop/features/home/views/home_view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  final UserModel currentUser;
  const MainView({super.key, required this.currentUser});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final CartProvider _cartProvider = CartProvider();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomwView(cartProvider: _cartProvider, currentUser: widget.currentUser),
      CartView(cartProvider: _cartProvider, currentUser: widget.currentUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: MyAppColor.primaryColor,
          unselectedItemColor: MyAppColor.subTitleText,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  if (_cartProvider.count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: MyAppColor.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          '${_cartProvider.count}',
                          style: const TextStyle(color: Colors.white, fontSize: 9),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              activeIcon: const Icon(Icons.shopping_bag),
              label: "Cart",
            ),
          ],
        ),
      ),
    );
  }
}
