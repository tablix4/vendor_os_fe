class SendOtpResponse {
  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;
  final String timestamp;
  final String path;

  const SendOtpResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.timestamp,
    required this.path,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json["success"] ?? false,
      statusCode: json["statusCode"] ?? 500,
      message: json["message"] ?? "",
      data: json["data"],
      timestamp: json["timestamp"] ?? "",
      path: json["path"] ?? "",
    );
  }
}