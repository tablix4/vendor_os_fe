class ProfileModel {
  final String id;
  final String email;
  final String name;
  final String status;
  final ShopModel? shop;

  const ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.status,
    this.shop,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? 'User',
      status: json['status']?.toString() ?? '',
      shop: json['shop'] != null &&
              json['shop'] is Map<String, dynamic>
          ? ShopModel.fromJson(
              json['shop'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String get shopName {
    final name = shop?.name.trim();

    if (name == null || name.isEmpty) {
      return 'Restaurant';
    }

    return name;
  }

  String get initial {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return 'U';
    }

    return trimmedName[0].toUpperCase();
  }
}

class ShopModel {
  final String id;
  final String ownerId;
  final String name;
  final String? logo;

  const ShopModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.logo,
  });

  factory ShopModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ShopModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Restaurant',
      logo: json['logo']?.toString(),
    );
  }
}