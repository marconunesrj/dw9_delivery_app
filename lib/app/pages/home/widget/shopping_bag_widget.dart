import 'package:dw9_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw9_delivery_app/app/dto/order_product_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingBagWidget extends StatelessWidget {
  final List<OrderProductDto> bag;
  const ShoppingBagWidget({
    super.key,
    required this.bag,
  });

  @override
  Widget build(BuildContext context) {
    var totalBag =
        bag.fold<double>(0.0, (total, element) => total += element.totalPrice);
    return Container(
      width: context.screenWidth,
      height: 90,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          _goOrder(context);
        },
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Ver Sacola',
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalBag.currencyPTBR,
                style: context.textStyles.textExtraBold.copyWith(
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goOrder(BuildContext context) async {
    // ! Guardando o context antes de executar await
    final navigator = Navigator.of(context);
    final sp = await SharedPreferences.getInstance();

    if (!sp.containsKey('accessToken')) {
      // Envio para o Login
      final loginResult = await navigator.pushNamed('/auth/login');
    }
    // Envio para o Order
  }
}
