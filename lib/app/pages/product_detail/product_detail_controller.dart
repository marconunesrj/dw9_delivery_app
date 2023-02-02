import 'package:bloc/bloc.dart';

class ProductDetailController extends Cubit<int> {
  late final bool _hasOrder;

  ProductDetailController()
      : super(1); // Valor inicial sempre igual a 1 pois é o amount inicial

  void initial(int amount, bool hasOrder) {
    _hasOrder = hasOrder;
    emit(amount);
  }

  void increment() => emit(state + 1);
  void decrement() {
    // Se houver Order pode chegar o zero para zerar o produto do carrinho ou senão deixa o padrão de 1
    if (state > (_hasOrder ? 0 : 1)) {
      emit(state - 1);
    }
  }
}
