import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  // Singleton
  ColorsApp._();

  static ColorsApp get instance {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0XFF007D21);

  Color get secondary => const Color(0XFFF88B0C);
}

// Criada a extension para facilitar o acesso as cores, adicionando no BuildContext
extension ColorsAppExtensions on BuildContext {
  ColorsApp get colorsApp => ColorsApp.instance;
}
