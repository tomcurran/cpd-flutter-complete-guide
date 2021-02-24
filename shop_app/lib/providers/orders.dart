import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          dateTime: DateTime.now(),
          products: products,
        ));
  }
}
