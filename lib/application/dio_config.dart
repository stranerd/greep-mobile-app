
import 'package:dio/dio.dart';
import 'package:grip/application/auth/AuthStore.dart';
import 'package:grip/domain/api.dart';


Dio dioClient() => Dio(BaseOptions(baseUrl: baseApi, connectTimeout: 60000))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) => requestInterceptors(options, handler),
  ));

requestInterceptors(
    RequestOptions options, RequestInterceptorHandler handler) async {
  print(options.path);
  var pref = AuthStore();
  var token = await pref.getAuthToken();
  options.contentType = "application/json";
  options.headers.putIfAbsent("Access-Token", () => "${token["token"] ??""}");
  handler.next(options);
}
