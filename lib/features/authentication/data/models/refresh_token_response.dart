class RefreshTokenResponse {
  final bool success;
  final int statusCode;
  final String message;
  final RefreshTokenData data;

  const RefreshTokenResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json["success"],
      statusCode: json["statusCode"],
      message: json["message"],
      data: RefreshTokenData.fromJson(json["data"]),
    );
  }
}

class RefreshTokenData {
  final String accessToken;
  final String refreshToken;

  const RefreshTokenData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenData.fromJson(Map<String, dynamic> json) {
    return RefreshTokenData(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}
