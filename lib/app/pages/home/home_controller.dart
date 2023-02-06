import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/pages/home/home_state.dart';
import 'package:dw9_delivery_app/app/repositories/products/products_repository.dart';

class HomeController extends Cubit<HomeState> {
  final ProductsRepository _productsRepository;

  HomeController(
    this._productsRepository,
  ) : super(const HomeState.initial());

  Future<void> loadProducts() async {
    emit(
      state.copyWith(
        status: HomeStateStatus.loading,
      ),
    );
    try {
      final products = await _productsRepository.findAllProducts();
      // throw Exception();  // Somente para testar um erro
      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          products: products,
        ),
      );
    } catch (e, s) {
      log('Erro ao buscar Produto', error: e, stackTrace: s);
      emit(
        state.copyWith(
            status: HomeStateStatus.error,
            errorMessage: 'Erro ao buscar Produto'),
      );
    }
  }

  void addOrUpdateBag(OrderProductDto orderProduct) {
    // duplicando o array
    final shoppingBag = [...state.shoppingBag];

    final orderIndex = shoppingBag
        .indexWhere((orderP) => orderP.product == orderProduct.product);

    // Encontrou o produto
    if (orderIndex > -1) {
      if (orderProduct.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProduct;
      }
    } else {
      // Não encontrou
      shoppingBag.add(orderProduct);
    }

    emit(
      state.copyWith(
        shoppingBag: shoppingBag,
      ),
    );
  }

  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
