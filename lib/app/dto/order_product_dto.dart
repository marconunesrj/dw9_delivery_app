import 'dart:convert';

import 'package:dw9_delivery_app/app/models/product_model.dart';

class OrderProductDto {
  final ProductModel product;
  final int amount;

  OrderProductDto({
    required this.product,
    required this.amount,
  });

  double get totalPrice => amount * product.price;

  OrderProductDto copyWith({
    ProductModel? product,
    int? amount,
  }) {
    return OrderProductDto(
      product: product ?? this.product,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'amount': amount,
    };
  }

  factory OrderProductDto.fromMap(Map<String, dynamic> map) {
    return OrderProductDto(
      product: ProductModel.fromMap(map['product']),
      amount: map['amount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderProductDto.fromJson(String source) =>
      OrderProductDto.fromMap(json.decode(source));
}
