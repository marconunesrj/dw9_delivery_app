import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dw9_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:dw9_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw9_delivery_app/app/models/product_model.dart';
import 'package:dw9_delivery_app/app/pages/product_detail/product_detail_controller.dart';

import '../../core/ui/base_state/base_state.dart';
import '../../core/ui/styles/text_styles.dart';
import '../../core/ui/widgets/delivery_increment_decrement_button.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final OrderProductDto? order;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required this.order,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState
    extends BaseState<ProductDetailPage, ProductDetailController> {
  @override
  void initState() {
    super.initState();
    final amount = widget.order?.amount ?? 1;
    // Para passar a quantidade (amount) já existente
    controller.initial(amount, widget.order != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            height: context.percentHeight(0.4),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(widget.product.name,
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 22,
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            // Para forçar a descrição ser com o maior tamanho possível para empurar os próximos widgets
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SingleChildScrollView(
                // Para fazer a rolagem apenas da descrição para caso de descrição muito grande
                child: Text(widget.product.description,
                    style: context.textStyles.textExtraBold.copyWith(
                      fontSize: 22,
                    )),
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Container(
                height: 68,
                width: context.percentWidth(0.5),
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return DeliveryIncrementDecrementButton(
                      amount: amount,
                      decrementTap: () {
                        controller.decrement();
                      },
                      incrementTap: () {
                        controller.increment();
                      },
                    );
                  },
                ),
              ),
              Container(
                width: context.percentWidth(0.5),
                height: 68,
                padding: const EdgeInsets.all(8),

                // Builda a tela
                child: BlocBuilder<ProductDetailController, int>(
                  // Amount é um int vindo do Controller
                  builder: (context, amount) {
                    return ElevatedButton(
                      // Trocar a cor do botão para vermelho se for para remover o item do carrinho
                      style: amount == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.red)
                          : null,
                      onPressed: () {
                        if (amount == 0) {
                          _showConfirmDelete(amount);
                        } else {
                          Navigator.of(context).pop(
                            OrderProductDto(
                              product: widget.product,
                              amount: amount,
                            ),
                          );
                        }
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text(
                          'Excluir Produto',
                          style: context.textStyles.textExtraBold,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Adicionar',
                              style: context.textStyles.textExtraBold.copyWith(
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                (widget.product.price * amount).currencyPTBR,
                                maxFontSize: 13,
                                minFontSize: 5,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style:
                                    context.textStyles.textExtraBold.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showConfirmDelete(int amount) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Deseja excluir o produto?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
                  Navigator.of(context).pop(
                    OrderProductDto(
                      product: widget.product,
                      amount: amount,
                    ),
                  );
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
