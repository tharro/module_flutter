import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:plugin_helper/plugin_app_environment.dart';
import '../../models/auth/get_started_model.dart';
import '../../models/auth/profile_model.dart';
import '../../repositories/auth/auth_repository.dart';
import '../../utils/parse_error.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:plugin_helper/plugin_authentication.dart';
import 'package:easy_localization/easy_localization.dart';

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
    on<AuthFCM>(authFCM);
  }

  void authResumeSession(
      AuthResumeSession event, Emitter<AuthState> emit) async {
    try {
      var hasToken = await MyPluginAuthentication.hasToken();
      if (hasToken) {
        if (!await MyPluginAuthentication.checkTokenValidity()) {
          await MyPluginAuthentication.refreshToken();
        }
        final profile = await authRepositories.getProfile();
        emit(state.copyWith(profileModel: profile));
        event.onSuccess(true);
      } else {
        event.onSuccess(false);
      }
    } catch (e) {
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authLogin(AuthLogin event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(loginLoading: true));
      final token = await MyPluginAuthentication.loginCognito(
        password: event.password,
        userName: event.userName,
      );
      ProfileModel profileModel = await authRepositories.getProfile();
      emit(state.copyWith(profileModel: profileModel, loginLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(loginLoading: false));
      event.onError(
          e.parseError.code,
          e.parseError.code == 'NotAuthorizedException'
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
        bool isVerify =
            MyPluginAppEnvironment().defaultVerify == DefaultVerify.email
                ? getStartedModel.isVerifiedEmail!
                : getStartedModel.isVerifiedPhone!;
        if (isVerify) {
          event.onSuccess(MyPluginAppConstraints.login);
        } else {
          event.onSuccess(MyPluginAppConstraints.verify);
        }
      } else {
        event.onSuccess(MyPluginAppConstraints.signUp);
      }
    } catch (e) {
      emit(state.copyWith(getStartedRequesting: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authResendCode(AuthResendCode event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(verifyCodeLoading: true));
      await MyPluginAuthentication.resendCodeCognito(userName: event.userName);
      emit(state.copyWith(verifyCodeLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(verifyCodeLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(signUpLoading: true));
      await MyPluginAuthentication.signUpCognito(
        id: event.body['id'],
        userAttributes: event.body['attr'],
        password: event.body['password'],
      );
      emit(state.copyWith(signUpLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(signUpLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authVerifyCode(AuthVerifyCode event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(verifyCodeLoading: true));

      await MyPluginAuthentication.verifyCodeCognito(
          userName: event.userName, code: event.code);
      if (event.password != null) {
        await MyPluginAuthentication.loginCognito(
          password: event.password!,
          userName: event.userName,
        );
        ProfileModel profileModel = await authRepositories.getProfile();
        emit(state.copyWith(
            profileModel: profileModel, verifyCodeLoading: false));
      } else {
        emit(state.copyWith(verifyCodeLoading: false));
      }
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(verifyCodeLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authForgotPassword(
      AuthForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(resetPasswordLoading: true));
      await MyPluginAuthentication.forgotPassword(userName: event.userName);
      event.onSuccess();
      emit(state.copyWith(resetPasswordLoading: false));
    } catch (e) {
      emit(state.copyWith(
        resetPasswordLoading: false,
      ));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authResetPassword(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(resetPasswordLoading: true));
      await MyPluginAuthentication.confirmNewPassword(
        code: event.code,
        newPassword: event.password,
        userName: event.userName,
      );
      await MyPluginAuthentication.loginCognito(
        password: event.password,
        userName: event.userName,
      );
      ProfileModel profileModel = await authRepositories.getProfile();
      emit(state.copyWith(
          profileModel: profileModel, resetPasswordLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(resetPasswordLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authUpdateProfile(
      AuthUpdateProfile event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(updateProfileLoading: true));
      String imageUrl = '';
      if (event.image != null) {
        imageUrl = await authRepositories.uploadImage(event.image!);
      }
      event.body['image'] = imageUrl;
      await authRepositories.updateProfile(body: event.body);
      ProfileModel profileModel = await authRepositories.getProfile();
      emit(state.copyWith(
          profileModel: profileModel, updateProfileLoading: false));
      event.onSuccess();
    } catch (e) {
      emit(state.copyWith(updateProfileLoading: false));
      event.onError(e.parseError.code, e.parseError.message);
    }
  }

  void authFCM(AuthFCM event, Emitter<AuthState> emit) async {
    try {
      await authRepositories.registerFCMDevice(body: event.body);
    } catch (e) {
      print(e);
    }
  }
}
