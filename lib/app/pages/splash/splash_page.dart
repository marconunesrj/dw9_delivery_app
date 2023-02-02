import 'package:dw9_delivery_app/app/core/ui/helpers/size_extensions.dart';
import 'package:dw9_delivery_app/app/core/ui/styles/colors_app.dart';
import 'package:flutter/material.dart';

import '../../core/ui/widgets/delivery_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Buscando da Classe ColorsApp através do extensions
    context.colorsApp.primary;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Splash'),
      // ),
      body: ColoredBox(
        color: const Color(0XFF140E0E),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: context.screenWidth,
                child: Image.asset(
                  'assets/images/lanche.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  // Criando um sizedbox com 30% do tamanho da tela
                  SizedBox(
                    height: context.percentHeight(.30),
                  ),
                  Image.asset('assets/images/logo.png'),
                  const SizedBox(
                    height: 80,
                  ),
                  DeliveryButton(
                    width: context.percentWidth(.6),
                    height: 35,
                    label: 'ACESSAR',
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/home');
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      // Column(
      //   children: [
      // Container(),
      // DeliveryButton(
      //   label: Env.instance['backend_base_url'] ?? '',
      //   onPressed: () {},
      //   width: 200,
      //   height: 200,
      // ),
      // Text(context.screenWidth
      //     .toString()), // Vem do arquivo Size_extensions.dart
      // Text(context.screenHeight.toString()),
      // Row(
      //   children: [
      //     Container(
      //       color: Colors.red,
      //       width: context.percentWidth(0.6),
      //       height: 200,
      //     ),
      //     Container(
      //       color: Colors.blue,
      //       width: context.percentWidth(0.4),
      //       height: 200,
      //     ),
      //   ],
      // ),
      // TextFormField(
      //   decoration: const InputDecoration(labelText: 'Teste'),
      // ),
      //   ],
      // ),
    );
  }
}
