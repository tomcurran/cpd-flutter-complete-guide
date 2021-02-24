import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order_item.dart' as providers;

class OrderItem extends StatefulWidget {
  final providers.OrderItem orderItem;

  const OrderItem({
    Key key,
    this.orderItem,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy').format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              height: min(widget.orderItem.products.length * 20 + 16.0, 100),
              child: ListView.builder(
                itemCount: widget.orderItem.products.length,
                itemBuilder: (ctx, i) {
                  final product = widget.orderItem.products[i];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${product.quantity}x \$${product.price}'),
                    ],
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
