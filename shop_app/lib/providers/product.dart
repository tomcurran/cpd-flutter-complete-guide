import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/config.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite() async {
    final previousIsFavourite = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final productUri = Uri.https(Config.FirebaseDomain, '/products/$id.json');
      final response = await http.patch(productUri,
          body: json.encode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = previousIsFavourite;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = previousIsFavourite;
      notifyListeners();
    }
  }
}
