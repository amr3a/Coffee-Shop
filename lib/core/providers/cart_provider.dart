import 'package:coffie_shop/core/models/proudct_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  int get count => _items.length;

  double get total => _items.fold(0, (sum, item) => sum + item.price);

  void addItem(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
