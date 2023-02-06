import 'package:dw9_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/models/payment_type_model.dart';
import 'package:dw9_delivery_app/app/pages/order/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/base_state/base_state.dart';
import '../../dto/order_dto.dart';
import 'order_controller.dart';
import 'widget/order_field.dart';
import 'widget/order_product_tile.dart';
import 'widget/payment_types_field.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final _addressEC = TextEditingController();
  final _documentEC = TextEditingController();
  int? paymentTypeId;
  // ! Utilizar isto nos campos específicos do meu projeto para validar aula 5
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(products);
  }

  @override
  void dispose() {
    _addressEC.dispose();
    _documentEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ficar escutando as alterações
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Erro não informado.');
          },
          confirmRemoveProduct: () {
            hideLoader();
            // Faz um Cast automático após esta verificação
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
                'Sua sacola está vazia, por favor selecione um produto para realizar seu pedido');
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: (() {
            hideLoader();
            Navigator.of(context).popAndPushNamed('/order/completed',
                result: <OrderProductDto>[]);
          }),
        );
      },
      child: WillPopScope(
        // Widget utilizado para Capturar o momento em que está saindo da tela
        // Será chamado quando apertar o botão de back da tela ou do celular
        onWillPop: () async {
          // vou forçar ele sair pelo Navigator para mandar o valor do carrinho como result.
          Navigator.of(context).pop(controller.state.orderProducts);
          // Bloqueia a saída da tela quando o valor retornado é false, forçando a saída pelo Navigator, ver chamada acima.
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Carrinho',
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                          onPressed: () => controller.emptyBag(),
                          icon: Image.asset(
                            'assets/images/trashRegular.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Extrai parte do estado
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProducts.length,
                        (context, index) {
                          final orderProduct = orderProducts[index];
                          return Column(
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProduct: orderProduct,
                              ),
                              const Divider(color: Colors.grey),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do pedido',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (state) => state.totalOrder,
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style:
                                      context.textStyles.textExtraBold.copyWith(
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      OrderField(
                        title: 'Endereço de entrega',
                        controller: _addressEC,
                        validator:
                            Validatorless.required('Endereço obrigatório'),
                        hintText: 'Digite um endereço',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      OrderField(
                        title: 'CPF',
                        controller: _documentEC,
                        validator: Validatorless.required('CPF obrigatório'),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentsTypes,
                        builder: (context, paymentsTypes) {
                          // Criar um Listener somente para o campo através da variável do tipo ValueNotifier -> paymentTypeValid
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                paymentsTypes: paymentsTypes,
                                // Para utilizar na validação deste campo
                                valueChanged: ((value) {
                                  paymentTypeId = value;
                                }),
                                valid: paymentTypeValidValue,
                                valueSelected: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  //fillOverscroll: true,
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          height: 35,
                          label: 'FINALIZAR',
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;

                            // Acionar o listener para o campo PaymentType para sua validação.
                            paymentTypeValid.value = paymentTypeSelected;
                            if (valid && paymentTypeSelected) {
                              controller.saveOrder(
                                address: _addressEC.text,
                                document: _documentEC.text,
                                paymentTypeId: paymentTypeId!,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Deseja excluir o produto ${state.orderProduct.product.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.cancelDeleteProcess();
                },
                child: Text(
                  'Cancelar',
                  style: context.textStyles.textBold.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Igual a chamada do cancelar com sintaxe reduzida
                  controller.decrementProduct(state.index);
                },
                child: Text(
                  'Confirmar',
                  style: context.textStyles.textBold,
                ),
              ),
            ],
          );
        });
  }
}
