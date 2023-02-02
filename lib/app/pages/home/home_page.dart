import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw9_delivery_app/app/pages/home/home_controller.dart';
import 'package:dw9_delivery_app/app/pages/home/home_state.dart';
import 'package:dw9_delivery_app/app/pages/home/widget/delivery_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ui/base_state/base_state.dart';
import 'widget/shopping_bag_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  // @override
  // void initState() {
  //   super.initState();
  //   ! Super IMPORTANTE substituir no meu projeto que está feito com isFirstTime
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     context.read<HomeController>().loadProducts();
  //   }); // Utilizado para carregar garantindo que a tela foi construída
  // }

  @override
  void onReady() {
    controller.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   showLoader();
      //   await Future.delayed(
      //     const Duration(
      //       seconds: 2,
      //     ),
      //   );
      //   hideLoader();
      //   showError('Error de Produto');
      //   await Future.delayed(
      //     const Duration(
      //       seconds: 2,
      //     ),
      //   );
      //   showInfo('Info de Produto');
      //   await Future.delayed(
      //     const Duration(
      //       seconds: 2,
      //     ),
      //   );
      //   showSuccess('Success de Produto');
      // }),
      body: BlocConsumer<HomeController, HomeState>(
        listener: (context, state) {
          // if ( state.status == HomeStateStatus.initial) {
          // } else if () {
          // }

          state.status.matchAny(
              any: () => hideLoader(),
              loading: () => showLoader(),
              error: () {
                hideLoader();
                showError(state.errorMessage ?? 'Erro não informado.');
              });
        },
        // Controlar quando rebuildar a tela
        buildWhen: (previous, current) => current.status.matchAny(
          any: () => false, // não faz nada
          initial: () => true, // rebuild a tela
          loaded: () => true, // rebuild a tela
        ),
        builder: (context, state) {
          return Column(
            children: [
              // Text(
              //   state.shoppingBag.length.toString(),
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    final orders = state.shoppingBag.where(
                      (order) => order.product == product,
                    );
                    return DeliveryProductTile(
                      product: product,
                      orderProduct: orders.isNotEmpty ? orders.first : null,
                    );
                  },
                ),
              ),
              Visibility(
                visible: state.shoppingBag.isNotEmpty,
                child: ShoppingBagWidget(bag: state.shoppingBag),
              ),
            ],
          );
        },
      ),
    );
  }
}
