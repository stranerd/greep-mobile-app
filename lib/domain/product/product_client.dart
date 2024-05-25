import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:greep/application/dio_config.dart';
import 'package:greep/application/response.dart';
import 'package:greep/domain/product/product.dart';

class ProductClient {
  final Dio dio = dioClient();

  Future<ResponseEntity<List<Product>>> fetchMarketplaceProducts({String? tagId}) async {
    Response response;
    try {
      Map<String,dynamic> query = {};
      if (tagId != null) {
        query = {
          "where[]": {
            "field": "tagIds",
            "relation": "IN",
            "value": tagId,
          },
          "all": "true"
        };
      }
      response = await dio.get("marketplace/products",queryParameters: query);
      List<Product> products = [];

      // print("response marketplace ${response.data} ");

      response.data["results"].forEach((e) {
        var product = Product.fromMap(e);
        print("Product: ${product.id}");
        products.add(product);
      });

      return ResponseEntity.Data(products);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching products";
        } else {
          message = error["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching products");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching products. Try again");
    }
  }

  Future<ResponseEntity<List<Product>>> searchProducts({required String query}) async {
    Response response;
    try {
      var search = {
        "fields": ["title"],
        "value": query,
      };
      Map<String, dynamic> queryParams = {
        "search": jsonEncode(search),
        "all": "true"
      };
      response = await dio.get("marketplace/products",queryParameters: queryParams);
      List<Product> products = [];

      // print("response marketplace ${response.data} ");

      response.data["results"].forEach((e) {
        var product = Product.fromMap(e);
        print("Product: ${product.id}");
        products.add(product);
      });

      return ResponseEntity.Data(products);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching products";
        } else {
          message = error["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching products");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching products. Try again");
    }
  }


  Future<ResponseEntity<List<Product>>> fetchRecommendedProducts() async {
    Response response;
    try {

      response = await dio.get("marketplace/products/recommendation/products",);
      List<Product> products = [];

      // print("response marketplace ${response.data} ");

      response.data["results"].forEach((e) {
        var product = Product.fromMap(e);
        print("Product: ${product.id}");
        products.add(product);
      });

      return ResponseEntity.Data(products);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("Recommendations error ${e.response?.statusCode} ${e.response?.data}");
        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching products";
        } else {
          message = error["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching products");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching products. Try again");
    }
  }


  Future<ResponseEntity<List<Product>>> fetchProductsByIds({required List<String> productIds}) async {
    Response response;
    try {
      Map<String,dynamic> query = {};
      var search = {
        "field": "id",
        "condition": "in",
        "value": productIds,
      };
        query = {
          "where[]": jsonEncode(search),
          "all": "true",
          "whereType": "and"
        };
      response = await dio.get("marketplace/products",queryParameters: query);
      List<Product> products = [];

      // print("response marketplace ${response.data} ");

      response.data["results"].forEach((e) {
        var product = Product.fromMap(e);
        print("Product: ${product.id}");
        products.add(product);
      });

      return ResponseEntity.Data(products);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return ResponseEntity.Timeout();
      }
      if (e.error is SocketException) {
        return ResponseEntity.Socket();
      }
      if (e.type == DioExceptionType.badResponse) {
        print("Error fetch products ${e.response?.data } ${e.response?.statusCode}");

        dynamic error = e.response!.data;
        String message = "";
        if (error == null) {
          message = "An error occurred fetching products";
        } else {
          message = error?.first?["message"] ?? "";
        }
        return ResponseEntity.Error(message);
      }
      return ResponseEntity.Error("An error occurred fetching products");
    } catch (e) {
      print("Exception $e");
      return ResponseEntity.Error(
          "An error occurred fetching products. Try again");
    }
  }

}
