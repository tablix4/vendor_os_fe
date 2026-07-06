class VerifyOtpResponse {
  final bool success;
  final String message;
  final VerifyOtpData data;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json["success"],
      message: json["message"],
      data: VerifyOtpData.fromJson(json["data"]),
    );
  }
}

class VerifyOtpData {
  final bool isNewUser;

  final String? tempToken;
  final String? accessToken;
  final String? refreshToken;

  VerifyOtpData({
    required this.isNewUser,
    this.tempToken,
    this.accessToken,
    this.refreshToken,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      isNewUser: json["isNewUser"],
      tempToken: json["tempToken"],
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}