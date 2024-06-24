import 'package:app_agendamento/src/core/restClient/interceptors/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

// final class RestClient extends DioForBrowser // Se for para WEB

final class RestClient extends DioForNative {
  RestClient()
      : super(BaseOptions(
          baseUrl: 'http://172.16.1.150:8080',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 60),
        )) {
    interceptors.addAll(
      [
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
        AuthInterceptor(),
      ],
    );
  }

  RestClient get auth {
    options.extra['DIO_AUTH_KEY'] = true;
    return this;
  }

  RestClient get unAuth {
    options.extra['DIO_AUTH_KEY'] = false;
    return this;
  }
}
