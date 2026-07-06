class CompleteProfileRequest {
  final String name;
  final String shopName;

  const CompleteProfileRequest({
    required this.name,
    required this.shopName,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "shopName": shopName,
    };
  }
}