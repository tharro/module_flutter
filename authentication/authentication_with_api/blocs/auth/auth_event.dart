part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthGetStarted extends AuthEvent {
  final Map<String, dynamic> body;
  final Function(String) onSuccess;
  final Function(String) onError;
  const AuthGetStarted(
      {required this.onError, required this.onSuccess, required this.body});
}

class AuthResumeSession extends AuthEvent {
  final Function(bool isResume) onSuccess;
  final Function(String) onError;
  const AuthResumeSession({required this.onSuccess, required this.onError});
}

class AuthLogin extends AuthEvent {
  final String userName, password;
  final Function onSuccess;
  final Function(String) onError;
  const AuthLogin(
      {required this.onError,
      required this.userName,
      required this.password,
      required this.onSuccess});
}

class AuthSignUp extends AuthEvent {
  final Map<String, dynamic> body;
  final Function onSuccess;
  final Function(String) onError;
  const AuthSignUp(
      {required this.onError, required this.body, required this.onSuccess});
}

class AuthLogout extends AuthEvent {
  const AuthLogout();
}

class AuthResendCode extends AuthEvent {
  final String userName;
  final String type;
  final Function onSuccess;
  final Function(String) onError;
  const AuthResendCode(
      {required this.userName,
      required this.type,
      required this.onError,
      required this.onSuccess});
}

class AuthVerifyCode extends AuthEvent {
  final String userName;
  final String type;
  final String? password;
  final String code;
  final Function onSuccess;
  final Function(String) onError;
  const AuthVerifyCode(
      {this.password,
      required this.code,
      required this.userName,
      required this.type,
      required this.onError,
      required this.onSuccess});
}

class AuthDismissError extends AuthEvent {}

class AuthUpdatePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  final Function onSuccess;
  final Function(String) onError;
  const AuthUpdatePassword(
      {required this.currentPassword,
      required this.newPassword,
      required this.onError,
      required this.onSuccess});
}

class AuthUpdateProfile extends AuthEvent {
  final PickedFile? image;
  final Map<String, dynamic> body;
  final Function() onSuccess;
  final Function(String) onError;
  const AuthUpdateProfile(
      {this.image,
      required this.body,
      required this.onError,
      required this.onSuccess});
}

class AuthForgotPassword extends AuthEvent {
  final String userName;
  final Function onSuccess;
  final Function(String) onError;
  const AuthForgotPassword(
      {required this.userName, required this.onError, required this.onSuccess});
}

class AuthResetPassword extends AuthEvent {
  final String code;
  final String password;
  final String userName;
  final Function onSuccess;
  final Function(String) onError;
  const AuthResetPassword({
    required this.code,
    required this.password,
    required this.onError,
    required this.onSuccess,
    required this.userName,
  });
}

class AuthFCM extends AuthEvent {
  final Map<String, dynamic> body;
  const AuthFCM({required this.body});
}
