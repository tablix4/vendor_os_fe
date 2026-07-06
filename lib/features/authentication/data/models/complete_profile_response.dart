class CompleteProfileResponse {
  final bool success;
  final String message;
  final CompleteProfileData data;

  CompleteProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompleteProfileResponse.fromJson(
      Map<String, dynamic> json) {
    return CompleteProfileResponse(
      success: json["success"],
      message: json["message"],
      data: CompleteProfileData.fromJson(json["data"]),
    );
  }
}

class CompleteProfileData {
  final String accessToken;
  final String refreshToken;

  CompleteProfileData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory CompleteProfileData.fromJson(
      Map<String, dynamic> json) {
    return CompleteProfileData(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}