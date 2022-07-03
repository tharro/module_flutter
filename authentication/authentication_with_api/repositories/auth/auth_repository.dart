import 'dart:io';
import 'package:plugin_helper/index.dart';

import '../../models/auth/token_model.dart';
import '../../api/apiUrl.dart';
import '../../models/auth/get_started_model.dart';
import '../../models/auth/profile_model.dart';
import '../../api/api.dart';

class AuthRepository extends Api {
  Future<ProfileModel> getProfile() async {
    final url = APIUrl.getProfile;
    final response = await request(
      url,
      Method.get,
    );
    return ProfileModel.fromJson(response.data);
  }

  Future<String> uploadImage(
      {required PickedFile file, Function(int, int)? onSendProgress}) async {
    final url = APIUrl.upload;
    String fileName = file.path.split('/').last;
    String fileType = mime(fileName)!.split('/').first;
    final response = await request(url, Method.post,
        body: {"file_type": fileType, "file_name": fileName});
    final uploadUrl = response.data['url'];
    final body = response.data['fields'];
    FormData data = FormData.fromMap({
      ...body,
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    await Dio().post(uploadUrl,
        options: Options(headers: {
          'cache-control': 'cache',
          'Content-Type': 'multipart/form-data',
          'Connection': 'keep-alive',
          'Accept': '*/*'
        }),
        data: data);
    return response.data['fields']['key'];
  }

  Future<void> updateProfile({required Map<String, dynamic> body}) async {
    final url = APIUrl.getProfile;
    await request(
      url,
      Method.put,
      body: body,
    );
  }

  Future<GetStartedModel> getStarted(Map<String, dynamic> params) async {
    final url = APIUrl.getStarted;
    final response =
        await request(url, Method.get, params: params, useIDToken: false);
    return GetStartedModel.fromJson(response.data);
  }

  Future<void> registerFCMDevice({required Map<String, dynamic> body}) async {
    final url = APIUrl.fcm;
    await request(url, Method.post, body: body);
  }

  Future<void> removeFCMDevice({required Map<String, dynamic> body}) async {
    final url = APIUrl.fcm;
    await request(url, Method.put, body: body);
  }

  Future<TokenModel> login(
      {required String userName, required String password}) async {
    final url = APIUrl.login;
    final response = await request(url, Method.post,
        body: {
          'username': userName,
          'password': password,
        },
        useIDToken: false);
    return TokenModel.fromJson(response.data);
  }

  Future<TokenModel> refreshToken({required String refreshToken}) async {
    final url = APIUrl.refreshToken;
    final response = await request(url, Method.post, body: {
      'refresh': refreshToken,
    });
    return TokenModel.fromJson(response.data);
  }

  Future<void> signUp(Map<String, dynamic> body) async {
    final url = APIUrl.signUp;
    await request(url, Method.post, body: body, useIDToken: false);
  }

  Future<void> verify(
      {required String userName,
      required String code,
      required String type}) async {
    final url = APIUrl.verify;
    await request(url, Method.post,
        body: {'username': userName, 'code': code, 'type': type},
        useIDToken: false);
  }

  Future<void> resendPassword({required String userName}) async {
    final url = APIUrl.resendPassword;
    await request(url, Method.post,
        body: {
          'username': userName,
        },
        useIDToken: false);
  }

  Future<void> resendCode(
      {required String userName, required String type}) async {
    final url = APIUrl.resendCode;
    await request(url, Method.post,
        body: {
          'username': userName,
          'type': type,
        },
        useIDToken: false);
  }

  Future<void> resetPassword(
      {required String userName,
      required String newPassword,
      required String code}) async {
    final url = APIUrl.resetPassword;
    await request(url, Method.post,
        body: {
          'username': userName,
          'password': newPassword,
          'code': code,
        },
        useIDToken: false);
  }

  Future<void> updatePassword(
      {required String newPassword, required String currentPassword}) async {
    final url = APIUrl.updatePassword;
    await request(url, Method.put, body: {
      'new_password': newPassword,
      'current_password': currentPassword
    });
  }
}
