import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GlobalContext {
  // ! Utilizada para Navegação sem contexto, NÃO UTILIZAR SEMPRE.
  // ! ATENÇÃO NUNCA deixar o navigatorKey como público!!!!!!!!!!!!
  late final GlobalKey<NavigatorState> _navigatorKey;

  static GlobalContext? _instance;
  // Avoid self isntance
  GlobalContext._();

  static GlobalContext get instance {
    _instance ??= GlobalContext._();
    return _instance!;
  }

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  Future<void> loginExpire() async {
    final sp = await SharedPreferences.getInstance();
    sp.clear();
    showTopSnackBar(
      _navigatorKey.currentState!.overlay!,
      const CustomSnackBar.error(
          message: 'Login expirado, clique na sacola novamente',
          backgroundColor: Colors.black),
    );
    // Limpa todas as telas e volta para a tela de Home
    _navigatorKey.currentState!.popUntil(ModalRoute.withName('/home'));
  }
}
