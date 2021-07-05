import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  const UserProductsScreen({Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    final productsData = Provider.of<Products>(context, listen: false);
    await productsData.fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) {
              var product = productsData.items[i];
              return Column(
                children: [
                  UserProductItem(
                    id: product.id,
                    title: product.title,
                    imageUrl: product.imageUrl,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
