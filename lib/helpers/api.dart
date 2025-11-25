import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(String url, dynamic data) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> get(String url) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> put(String url, dynamic data) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> delete(String url) async {
    var token = await UserInfo().getToken();
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      return _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
