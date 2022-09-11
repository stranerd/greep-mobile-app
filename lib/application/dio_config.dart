import 'package:dio/dio.dart';
import 'package:grip/application/auth/AuthStore.dart';
import 'package:grip/domain/api.dart';


Dio dioClient({bool useRefreshToken = false}) => Dio(BaseOptions(baseUrl: baseApi, connectTimeout: 60000))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) => requestInterceptors(options, handler,useRefreshToken:useRefreshToken),
    // onResponse: (options, handler) => responseInterceptor(options, handler)
  ));

requestInterceptors(
    RequestOptions options, RequestInterceptorHandler handler,{ bool useRefreshToken = false}) async {
  print("$baseApi${options.path}");
  var pref = AuthStore();
  var token = await pref.getAuthToken();
  options.contentType = "application/json";
  options.headers["Access-Token"] = "${token["token"]??""}";
  options.headers["Accept"] = "*/*";
  handler.next(options);
}
//
// responseInterceptor(
//     Response options, ResponseInterceptorHandler handler) async {
//   print("status code: ${options.statusCode}");
//   print("request url: ${options.requestOptions.path}");
//
//   var pref = AuthStore();
//   var token = await pref.getAuthToken();
//   print("refresh token ${token["refreshToken"]}");
//   print("token ${token["token"]}");
//
//
//   handler.next(options);
// }
