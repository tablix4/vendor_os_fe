import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

final profileProvider =
    StateNotifierProvider<
        ProfileNotifier,
        AsyncValue<ProfileModel>>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier
    extends StateNotifier<
        AsyncValue<ProfileModel>> {
  final ProfileRepository _repository =
      ProfileRepository();

  ProfileNotifier()
      : super(
          const AsyncValue.loading(),
        ) {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    state =
        const AsyncValue.loading();

    try {
      final profile =
          await _repository
              .getProfile();

      state =
          AsyncValue.data(profile);
    } catch (
      error,
      stackTrace
    ) {
      state =
          AsyncValue.error(
        error,
        stackTrace,
      );
    }
  }

  Future<void>
      refreshProfile() async {
    try {
      final profile =
          await _repository
              .getProfile();

      state =
          AsyncValue.data(profile);
    } catch (
      error,
      stackTrace
    ) {
      state =
          AsyncValue.error(
        error,
        stackTrace,
      );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String shopName,
  }) async {
    await _repository.updateProfile(
      name: name,
      shopName: shopName,
    );

    await refreshProfile();
  }
}