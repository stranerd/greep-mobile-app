import 'package:dio/dio.dart';
import 'package:greep/application/auth/AuthStore.dart';
import 'package:greep/domain/api.dart';

Dio dioClient({bool useRefreshToken = false}) =>
    Dio(BaseOptions(baseUrl: baseApi, connectTimeout: Duration(seconds: 60)))
      ..interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) => requestInterceptors(options, handler,
            useRefreshToken: useRefreshToken),
        // onResponse: (options, handler) => responseInterceptor(options, handler)
      ));

requestInterceptors(RequestOptions options, RequestInterceptorHandler handler,
    {bool useRefreshToken = false}) async {
  print("$baseApi${options.path}");
  var pref = AuthStore();
  var token = await pref.getAuthToken();
  options.contentType = "application/json";
  if (useRefreshToken) {
    options.headers["Refresh-Token"] = "${token["refreshToken"] ?? ""}";
  }
  options.headers["Access-Token"] = "${token["token"] ?? ""}";
  options.headers["Accept"] = "*/*";
  handler.next(options);
}
