import 'package:plugin_helper/plugin_helper.dart';

class TokenModel extends Equatable {
  final String token;
  final String refreshToken;
  final int expiredToken;
  final int expiredRefreshToken;

  const TokenModel({
    required this.expiredToken,
    required this.token,
    required this.refreshToken,
    required this.expiredRefreshToken,
  });

  factory TokenModel.fromJson(dynamic json) {
    return TokenModel(
        refreshToken: json['refresh'],
        token: json['token'],
        expiredToken: json['exp'],
        expiredRefreshToken: json['exp_rf']);
  }

  TokenModel copyWith(
      {String? token,
      String? refreshToken,
      int? expiredToken,
      int? expiredRefreshToken}) {
    return TokenModel(
      refreshToken: refreshToken ?? this.refreshToken,
      token: token ?? this.token,
      expiredToken: expiredToken ?? this.expiredToken,
      expiredRefreshToken: expiredRefreshToken ?? this.expiredRefreshToken,
    );
  }

  @override
  List<Object?> get props =>
      [refreshToken, expiredToken, expiredRefreshToken, token];
}
