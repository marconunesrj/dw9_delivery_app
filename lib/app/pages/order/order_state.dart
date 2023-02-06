import 'package:dw9_delivery_app/app/models/payment_type_model.dart';
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';

part 'order_state.g.dart'; // Para utilizar o match_generator -> executar no terminal: flutter pub run build_runner watch -d

@match
enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  updateOrder,
  confirmRemoveProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> orderProducts;
  final List<PaymentTypeModel> paymentsTypes;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.orderProducts,
    required this.paymentsTypes,
    this.errorMessage,
  });

  const OrderState.initial()
      : status = OrderStatus.initial,
        orderProducts = const [],
        paymentsTypes = const [],
        errorMessage = null;

  @override
  List<Object?> get props =>
      [status, orderProducts, paymentsTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? orderProducts,
    List<PaymentTypeModel>? paymentsTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProducts: orderProducts ?? this.orderProducts,
      paymentsTypes: paymentsTypes ?? this.paymentsTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get totalOrder => orderProducts.fold(
      0.0, (previousValue, element) => previousValue + element.totalPrice);
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.status,
    required super.orderProducts,
    required super.paymentsTypes,
    super.errorMessage,
  });
}
