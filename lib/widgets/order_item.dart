import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/const_data.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widgets/image_url_show.dart';

import '../provider/orders.dart' as orItem;

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.order});
  final orItem.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<ProductsProvider>(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 100.0 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        color: Colors.blueGrey,
        shape: borderCartScreen,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  '\$ ${widget.order.amount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                subtitle: Text(DateFormat('yyyy/MM/dd   hh:mm')
                    .format(widget.order.dateTime)),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  height: _expanded
                      ? min(widget.order.products.length * 70.0 + 30, 110)
                      : 0,
                  decoration: const BoxDecoration(color: Colors.black12),
                  child: ListView(
                      children: widget.order.products
                          .map(
                            (ele) => Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipOval(
                                    child: SizedBox(
                                      height: 40.0,
                                      width: 40.0,
                                      child: Image.network(
                                        pro.imageUrl(ele.title),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Text(ele.title),
                                  Text('${ele.quantity} X \$${ele.price}')
                                ],
                              ),
                              const Divider(
                                thickness: 1.0,
                                color: Colors.orange,
                              ),
                            ]),
                          )
                          .toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
