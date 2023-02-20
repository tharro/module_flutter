import 'dart:collection';
import 'dart:io';
import '../../api/apiUrl.dart';

import '../../models/auth/token_model.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:plugin_helper/index.dart';

//This plugin had used to make the HTTP method request
enum Method { post, put, patch, delete, get }

class Api {
  static final dio = Dio();

  Future<Response> request(
    url,
    Method method, {
    body,
    Map<String, dynamic>? params,
    useIDToken = true,
    headersOverwrite,
    customContentType,
    Map<String, dynamic>? customHeader,
    Map<String, dynamic>? headerAddition,
    Function(int, int)? onSendProgress,
    Options? cacheOptions,
  }) async {
    Map headers = {
      'cache-control': 'cache',
      'Content-Type': customContentType ?? 'application/json',
      'Connection': 'keep-alive'
    };

    var combinedMap = headers;
    if (headersOverwrite != null) {
      var mapList = [headers, headersOverwrite];
      combinedMap = mapList.reduce((map1, map2) => map1..addAll(map2));
    }
    Map<String, dynamic> header = customHeader ?? HashMap.from(combinedMap);
    if (headerAddition != null) {
      header.addAll(headerAddition);
    }
    String _languageCode = await MyPluginHelper.getLanguage();
    if (params != null) {
      params = params..addAll({'language_code': _languageCode});
    } else {
      params = {'language_code': _languageCode};
    }

    if (useIDToken) {
      if (await MyPluginAuthentication.hasToken()) {
        if (!await MyPluginAuthentication.checkTokenValidity()) {
          final users = await MyPluginAuthentication.getUser();
          final response = await dio.post(APIUrl.refreshToken,
              data: {'refresh': users.refreshToken},
              options: Options(
                headers: header,
              ),
              queryParameters: params,
              onSendProgress: onSendProgress);
          final TokenModel tokenModel = TokenModel.fromJson(response.data);
          await MyPluginAuthentication.persistUser(
            userId: users.userId!,
            token: tokenModel.token,
            refreshToken: tokenModel.refreshToken,
            expiredToken: tokenModel.expiredToken * 1000,
            expiredRefreshToken: tokenModel.expiredRefreshToken * 1000,
          );
        }
      }
      final users = await MyPluginAuthentication.getUser();
      header['Authorization'] = 'Bearer ${users.token}';
    }

    try {
      if (method == Method.post) {
        return await dio.post(url,
            data: body,
            options: Options(
              headers: header,
            ),
            queryParameters: params,
            onSendProgress: onSendProgress);
      } else if (method == Method.put) {
        return await dio.put(
          url,
          data: body,
          options: Options(headers: header),
          queryParameters: params,
          onSendProgress: onSendProgress,
        );
      } else if (method == Method.patch) {
        return await dio.patch(url,
            data: body,
            options: Options(headers: header),
            queryParameters: params);
      } else if (method == Method.delete) {
        return await dio.delete(url,
            options: Options(headers: header),
            data: body,
            queryParameters: params);
      }

      return await dio.get(url,
          options: cacheOptions != null
              ? cacheOptions.copyWith(headers: header)
              : Options(headers: header),
          queryParameters: params);
    } catch (e) {
      print("📕 error at api: $url");
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        throw PlatformException(
          code: 'NOT_CONNECTED',
          message: MyPluginMessageRequire.noConnection,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<Response<dynamic>> requestUploadFile(url, Method method, File file,
      {String? typeFile,
      Map<String, dynamic>? body,
      Map<String, dynamic>? customHeader,
      Function(int, int)? onSendProgress}) async {
    String fileName = file.path.split('/').last;
    String mimeType = mime(fileName)!;
    String mimee = mimeType.split('/')[0];
    String type = mimeType.split('/')[1];
    FormData data = FormData.fromMap(
      {
        "file": await MultipartFile.fromFile(file.path,
            filename: fileName,
            contentType: MediaType(mimee, typeFile ?? type)),
      }..addAll(body ?? {}),
    );

    return await request(url, method, customHeader: customHeader, body: data,
        onSendProgress: (value, total) {
      if (onSendProgress != null) {
        onSendProgress(value, total);
      }
    });
  }
}
