import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Env? _instance;

  Env._();

  static Env get instance {
    _instance ??= Env._();
    return _instance!;
  }

  // Carregar no início da aplicação //  Não utilizar em produção deverá trocar somente aqui pela nova implementação.
  Future<void> load() => dotenv.load();

  // Operator Method
  String? operator [](String key) => dotenv.env[key];
}
