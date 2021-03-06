import 'dart:io';

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

  Future<String> uploadImage(File file) async {
    final url = APIUrl.upload;
    final response = await requestUploadFile(url, Method.post, file,
        body: {'type': 'image'});
    return response.data['results'];
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
}
