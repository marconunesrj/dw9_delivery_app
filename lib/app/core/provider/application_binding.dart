import 'package:dw9_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dw9_delivery_app/app/repositories/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../repositories/auth/auth_repository_impl.dart';

class ApplicationBinding extends StatelessWidget {
  final Widget child;

  const ApplicationBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Aqui são colocados os providers que serão disponibilizados para a Aplicação como um todo(Geral)
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => CustomDio(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            dio: context.read(),
          ), // context.read() -> Vai ler através da injeção de dependência
        ),
      ],
      child: child,
    );
  }
}
