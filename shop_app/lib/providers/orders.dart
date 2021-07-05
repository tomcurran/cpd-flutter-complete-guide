import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_app/config.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final ordersUri = Uri.https(Config.FirebaseDomain, '/orders.json');
      final response = await http.get(ordersUri);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data != null) {
        final orders = data.entries
            .map((ordersResponse) => OrderItem(
                id: ordersResponse.key,
                amount: ordersResponse.value['amount'],
                dateTime: DateTime.parse(ordersResponse.value['dateTime']),
                products: (ordersResponse.value['products'] as List<dynamic>)
                    .map((cardItemResponse) => CartItem(
                          id: cardItemResponse['id'],
                          price: cardItemResponse['price'],
                          quantity: cardItemResponse['quantity'],
                          title: cardItemResponse['title'],
                        ))
                    .toList()))
            .toList();
        orders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        _orders = orders;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    try {
      final ordersUri = Uri.https(Config.FirebaseDomain, '/orders.json');
      final timestamp = DateTime.now();
      final response = await http.post(ordersUri,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': products
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: products,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
