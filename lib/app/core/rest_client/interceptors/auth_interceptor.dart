import 'package:dio/dio.dart';
import 'package:dw9_delivery_app/app/core/global/global_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  // Este interceptor vai ser executado antes do request
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final sp = await SharedPreferences.getInstance();

    final accessToken = sp.getString('accessToken');

    // Adicionar o Token no Header
    options.headers['Authorization'] = 'Bearer $accessToken';

    // ! Tem que ter esta linha para que possa prosseguir, Tipo Filter no Java
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Redirecionar o usuário para a Tela de Home para fazer login novamente
      GlobalContext.instance.loginExpire();
    } else {
      handler.next(err);
    }
  }
}
