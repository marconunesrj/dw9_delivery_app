import 'package:dw9_delivery_app/app/core/global/global_context.dart';
import 'package:dw9_delivery_app/app/core/ui/theme/theme_config.dart';
import 'package:dw9_delivery_app/app/pages/auth/login/login_router.dart';
import 'package:dw9_delivery_app/app/pages/home/home_router.dart';
import 'package:dw9_delivery_app/app/pages/order/order_completed_page.dart';
import 'package:dw9_delivery_app/app/pages/order/order_router.dart';
import 'package:dw9_delivery_app/app/pages/product_detail/product_detail_router.dart';
import 'package:flutter/material.dart';

import 'core/provider/application_binding.dart';
import 'pages/auth/register/register_router.dart';
import 'pages/splash/splash_page.dart';

class Dw9DeliveryApp extends StatelessWidget {
  final _navigatorKey =
      GlobalKey<NavigatorState>(); // para fazer navegação sem contexto

  Dw9DeliveryApp({super.key}) {
    GlobalContext.instance.navigatorKey =
        _navigatorKey; // para fazer navegação sem contexto
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        navigatorKey: _navigatorKey, // para fazer navegação sem contexto
        title: 'Delivery App',
        theme: ThemeConfig.theme,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
          '/productDetail': (context) => ProductDetailRouter.page,
          '/auth/login': (context) => LoginRouter.page,
          '/auth/register': (context) => RegisterRouter.page,
          '/order': (context) => OrderRouter.page,
          '/order/completed': ((context) => const OrderCompletedPage())
        },
      ),
    );
  }
}
