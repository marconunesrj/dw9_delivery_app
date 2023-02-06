import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dw9_delivery_app/app/dto/order_dto.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';

import '../../repositories/order/order_repository.dart';
import 'order_state.dart';

class OrderController extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderController(
    this._orderRepository,
  ) : super(const OrderState.initial());

  Future<void> load(List<OrderProductDto> orderProducts) async {
    emit(state.copyWith(status: OrderStatus.loading));

    try {
      final paymentTypes = await _orderRepository.getAllPaymentsTypes();
      // throw Exception();  // Somente para testar um erro
      emit(state.copyWith(
        orderProducts: orderProducts,
        status: OrderStatus.loaded,
        paymentsTypes: paymentTypes,
      ));
    } catch (e, s) {
      log('Erro ao carregar página', error: e, stackTrace: s);
      emit(
        state.copyWith(
            status: OrderStatus.error, errorMessage: 'Erro ao carregar página'),
      );
    }
  }

  void incrementProduct(int index) {
    // Duplicar a lista para dizer ao Bloc que a lista foi alterada
    final orders = [...state.orderProducts];
    final order = orders[index];

    // Para incrementar tem que utilizar o copyWith, pois o amount é tipo final.
    orders[index] = order.copyWith(amount: order.amount + 1);
    emit(
        state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void decrementProduct(int index) {
    // Duplicar a lista para dizer ao Bloc que a lista foi alterada
    final orders = [...state.orderProducts];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(OrderConfirmDeleteProductState(
          orderProduct: order,
          index: index,
          status: OrderStatus.confirmRemoveProduct,
          orderProducts: state.orderProducts,
          paymentsTypes: state.paymentsTypes,
          errorMessage: state.errorMessage,
        ));
        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    } else {
      // Para decrementar tem que utilizar o copyWith, pois o amount é tipo final.
      emit(state.copyWith(
          orderProducts: orders, status: OrderStatus.updateOrder));
    }
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  void saveOrder({
    required String address,
    required String document,
    required int paymentTypeId,
  }) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await _orderRepository.saveOrder(
      OrderDto(
        products: state.orderProducts,
        address: address,
        document: document,
        paymentMethodId: paymentTypeId,
      ),
    );
    emit(state.copyWith(status: OrderStatus.success));
  }
}
