import 'dart:io';

import 'package:plugin_firebase/index.dart';
import 'package:plugin_helper/index.dart';

import '../../index.dart';
import '../../models/auth/get_started_model.dart';
import '../../models/auth/profile_model.dart';
import '../../models/auth/token_model.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../screens/auth/get_started.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepositories = AuthRepository();
  AuthBloc() : super(AuthState.empty()) {
    on<AuthResumeSession>(authResumeSession);
    on<AuthGetStarted>(authGetStarted);
    on<AuthLogin>(authLogin);
    on<AuthSignUp>(authSignUp);
    on<AuthResendCode>(authResendCode);
    on<AuthVerifyCode>(authVerifyCode);
    on<AuthUpdateProfile>(authUpdateProfile);
    on<AuthForgotPassword>(authForgotPassword);
    on<AuthResetPassword>(authResetPassword);
    on<AuthUpdatePassword>(authUpdatePassword);
    on<AuthFCM>(authFCM);
    on<AuthLogout>(authLogout);
  }

  void authResumeSession(
      AuthResumeSession event, Emitter<AuthState> emit) async {
    try {
      var hasToken = await MyPluginAuthentication.hasToken();
      if (hasToken) {
        final profile = await authRepositories.getProfile();
        emit(state.copyWith(profileModel: profile));
        event.onSuccess(true);
      } else {
        event.onSuccess(false);
      }
    } catch (e) {
      event.onError(e.parseError.message);
    }
  }

  void authLogin(AuthLogin event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(loginLoading: true));
      final TokenModel tokenModel = await authRepositories.login(
        password: event.password,
        id: event.id,
      );
      await MyPluginAuthentication.persistUser(
        userId: event.id,
        token: tokenModel.token,
        refreshToken: tokenModel.refreshToken,
        expiredToken: tokenModel.expiredToken * 1000,
        expiredRefreshToken: tokenModel.expiredRefreshToken * 1000,
      );
      ProfileModel profileModel = await authRepositories.getProfile();
      emit(state.copyWith(profileModel: profileModel, loginLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(loginLoading: false));
      Helper.showToastBottom(
          message: e.parseError.code == 'NotAuthorizedException'
              ? 'key_wrong_password'.tr()
              : e.parseError.message);
    }
  }

  void authGetStarted(AuthGetStarted event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(getStartedRequesting: true));
      GetStartedModel getStartedModel =
          await authRepositories.getStarted(event.body);
      emit(state.copyWith(
          getStartedModel: getStartedModel, getStartedRequesting: false));
      if (getStartedModel.isRegistered!) {
        if (getStartedModel.isVerifiedEmail! &&
            getStartedModel.isVerifiedPhone!) {
          event.onSuccess(MyPluginAppConstraints.login);
        } else {
          event.onSuccess(MyPluginAppConstraints.verify);
        }
      } else {
        event.onSuccess(MyPluginAppConstraints.signUp);
      }
    } catch (e) {
      emit(state.copyWith(getStartedRequesting: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authResendCode(AuthResendCode event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(verifyCodeLoading: true));
      await authRepositories.resendCode(id: event.id, type: event.type);
      emit(state.copyWith(verifyCodeLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(verifyCodeLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(signUpLoading: true));
      String id = await authRepositories.signUp(event.body);
      GetStartedModel getStartedModel = state.getStartedModel!.copyWith(
          email: event.body['email'], phone: event.body['phone'], id: id);
      emit(state.copyWith(
          getStartedModel: getStartedModel, signUpLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(signUpLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authVerifyCode(AuthVerifyCode event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(verifyCodeLoading: true));
      await authRepositories.verify(
          id: event.id, code: event.code, type: event.type);
      GetStartedModel? getStartedModel = event.type == 'email'
          ? state.getStartedModel!.copyWith(isVerifiedEmail: true)
          : state.getStartedModel!.copyWith(isVerifiedPhone: true);
      if (event.password != null) {
        final TokenModel tokenModel = await authRepositories.login(
          password: event.password!,
          id: event.id,
        );
        await MyPluginAuthentication.persistUser(
          userId: event.id,
          token: tokenModel.token,
          refreshToken: tokenModel.refreshToken,
          expiredToken: tokenModel.expiredToken * 1000,
          expiredRefreshToken: tokenModel.expiredRefreshToken * 1000,
        );
        if (getStartedModel.isVerifiedEmail! &&
            getStartedModel.isVerifiedPhone!) {
          ProfileModel? profileModel = await authRepositories.getProfile();
          emit(state.copyWith(
            profileModel: profileModel,
            verifyCodeLoading: false,
            getStartedModel: getStartedModel,
          ));
        } else {
          emit(state.copyWith(
            verifyCodeLoading: false,
            getStartedModel: getStartedModel,
          ));
        }
      } else {
        emit(state.copyWith(
          verifyCodeLoading: false,
          getStartedModel: getStartedModel,
        ));
      }
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(verifyCodeLoading: false));
      event.onError(e.parseError.message);
    }
  }

  void authForgotPassword(
      AuthForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(resetPasswordLoading: true));
      await authRepositories.resendPassword(id: event.id);
      event.onSuccess();
      emit(state.copyWith(resetPasswordLoading: false));
    } catch (e) {
      emit(state.copyWith(resetPasswordLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authResetPassword(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(resetPasswordLoading: true));
      await authRepositories.resetPassword(
        code: event.code,
        newPassword: event.password,
        id: event.id,
      );
      final TokenModel tokenModel = await authRepositories.login(
        password: event.password,
        id: event.id,
      );
      await MyPluginAuthentication.persistUser(
        userId: event.id,
        token: tokenModel.token,
        refreshToken: tokenModel.refreshToken,
        expiredToken: tokenModel.expiredToken * 1000,
        expiredRefreshToken: tokenModel.expiredRefreshToken * 1000,
      );
      ProfileModel profileModel = await authRepositories.getProfile();
      emit(state.copyWith(
          profileModel: profileModel, resetPasswordLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(resetPasswordLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authUpdateProfile(
      AuthUpdateProfile event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(updateProfileLoading: true));
      String imageUrl = '';
      if (event.image != null) {
        imageUrl =
            await authRepositories.uploadImage(file: File(event.image!.path));
        event.body['image'] = imageUrl;
      }
      await authRepositories.updateProfile(body: event.body);
      ProfileModel profileModel = await authRepositories.getProfile();
      emit(state.copyWith(
          profileModel: profileModel, updateProfileLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(updateProfileLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authUpdatePassword(
      AuthUpdatePassword event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(updatePasswordLoading: true));
      await authRepositories.updatePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword);
      emit(state.copyWith(updatePasswordLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(updatePasswordLoading: false));
      Helper.showToastBottom(message: e.parseError.message);
    }
  }

  void authFCM(AuthFCM event, Emitter<AuthState> emit) async {
    try {
      await authRepositories.registerFCMDevice(body: event.body);
    } catch (e) {
      print(e);
    }
  }

  void authLogout(AuthLogout event, Emitter<AuthState> emit) async {
    try {
      popUtil(const GetStarted());
      try {
        Map<String, dynamic> body =
            await MyPluginNotification.getInfoToRequest();
        await authRepositories.removeFCMDevice(body: body);
      } catch (e) {}
      await MyPluginAuthentication.deleteUser();
      await MyPluginHelper.setFirstInstall();
    } catch (e) {
      toast(e.parseError.message);
    }
  }
}
