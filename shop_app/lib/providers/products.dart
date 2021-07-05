import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/config.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    */
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final productsUri = Uri.https(Config.FirebaseDomain, '/products.json');
      final response = await http.get(productsUri);
      final data = json.decode(response.body) as Map<String, dynamic>;
      _items = data.entries
          .map((productResponse) => Product(
                id: productResponse.key,
                title: productResponse.value['title'],
                description: productResponse.value['description'],
                price: productResponse.value['price'],
                isFavourite: productResponse.value['isFavourite'],
                imageUrl: productResponse.value['imageUrl'],
              ))
          .toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final productsUri = Uri.https(Config.FirebaseDomain, '/products.json');
      final response = await http.post(productsUri,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
      if (prodIndex >= 0) {
        final productUri = Uri.https(
          'cpd-flutter-complete-guide-default-rtdb.europe-west1.firebasedatabase.app',
          '/products/${product.id}.json',
        );
        await http.patch(productUri,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
            }));
        _items[prodIndex] = product;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final productUri =
          Uri.https(Config.FirebaseDomain, '/products/$productId.json');
      final response = await http.delete(productUri);
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product');
      }
      _items.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
