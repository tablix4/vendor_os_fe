class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "http://192.168.1.7:3000/api";

  static const String sendOtp = "/auth/send-otp";
  static const String verifyOtp = "/auth/verify-otp";
  static const String completeProfile = "/auth/complete-profile";
  static const refreshToken = "/auth/refresh";
  static const categories = "/categories";
  static const menuItems = "/menu-items";
  static const String orders = "/orders";
}
