import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

class ProfileService {
  Future<ProfileModel> getProfile() async {
    final Response response =
        await ApiClient.dio.get(
      ApiConstants.userProfile,
    );

    final responseData = response.data;

    if (responseData
        is! Map<String, dynamic>) {
      throw Exception(
        'Invalid profile response',
      );
    }

    final success =
        responseData['success'];

    if (success != true) {
      throw Exception(
        responseData['message']
                ?.toString() ??
            'Unable to fetch profile',
      );
    }

    final data =
        responseData['data'];

    if (data
        is! Map<String, dynamic>) {
      throw Exception(
        'Profile data not found',
      );
    }

    return ProfileModel.fromJson(
      data,
    );
  }

  Future<void> updateProfile({
    required String name,
    required String shopName,
  }) async {
    final Response response =
        await ApiClient.dio.patch(
      ApiConstants.updateUserProfile,
      data: {
        'name': name,
        'shopName': shopName,
      },
    );

    final responseData = response.data;

    if (responseData
        is Map<String, dynamic>) {
      final success =
          responseData['success'];

      if (success == false) {
        throw Exception(
          responseData['message']
                  ?.toString() ??
              'Unable to update profile',
        );
      }
    }
  }
}