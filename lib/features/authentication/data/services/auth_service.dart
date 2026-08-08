import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:my_hr/core/network/api_client.dart';
import 'package:my_hr/features/authentication/data/models/logout_response.dart';
import 'package:my_hr/features/authentication/data/models/refresh_token_request.dart';
import 'package:my_hr/features/authentication/data/models/refresh_token_response.dart';

import '../models/verify_otp_request.dart';
import '../models/verify_otp_response.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/send_otp_request.dart';
import '../models/send_otp_response.dart';
import '../models/complete_profile_request.dart';
import '../models/complete_profile_response.dart';

class AuthService {
  Future<SendOtpResponse> sendOtp(SendOtpRequest request) async {
    try {
      print("========== SEND OTP ==========");
      print("BASE URL: ${ApiConstants.baseUrl}");
      print("ENDPOINT: ${ApiConstants.sendOtp}");

      final response = await ApiClient.dio.post(
        ApiConstants.sendOtp,
        data: request.toJson(),
      );

      print("SUCCESS");
      print(response.data);

      return SendOtpResponse.fromJson(response.data);
    } on DioException catch (e) {
      print("========== DIO ERROR ==========");
      print("TYPE: ${e.type}");
      print("MESSAGE: ${e.message}");
      print("URI: ${e.requestOptions.uri}");
      print("ERROR: ${e.error}");
      print("RESPONSE: ${e.response?.data}");
      rethrow;
    }
  }

  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.verifyOtp}"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("OTP Verification Failed");
    }

    return VerifyOtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<CompleteProfileResponse> completeProfile(
    String tempToken,
    CompleteProfileRequest request,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.completeProfile}"),
      headers: {
        "Authorization": "Bearer $tempToken",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Complete Profile Failed");
    }

    return CompleteProfileResponse.fromJson(jsonDecode(response.body));
  }

  Future<LogoutResponse> logout(String accessToken) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/logout"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Logout failed");
    }

    return LogoutResponse.fromJson(jsonDecode(response.body));
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}${ApiConstants.refreshToken}"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Refresh Token Failed");
    }

    return RefreshTokenResponse.fromJson(jsonDecode(response.body));
  }
}
