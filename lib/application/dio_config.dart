
import 'package:dio/dio.dart';
import 'package:grip/application/auth/AuthStore.dart';
import 'package:grip/domain/api.dart';


Dio dioClient({bool useRefreshToken = false}) => Dio(BaseOptions(baseUrl: baseApi, connectTimeout: 60000))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) => requestInterceptors(options, handler,useRefreshToken:useRefreshToken),
  ));

requestInterceptors(
    RequestOptions options, RequestInterceptorHandler handler,{ bool useRefreshToken = false}) async {
  print(options.path);
  var pref = AuthStore();
  var token = await pref.getAuthToken();
    print("${useRefreshToken ? "": "not"} using refresh token ${token["token"]}");
  options.contentType = "application/json";
  options.headers["Access-Token"] = "${token["token"]??""}";
  options.headers["Accept"] = "*/*";
  print(options.headers);
  handler.next(options);
}
