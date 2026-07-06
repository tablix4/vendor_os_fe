class CreateMenuRequest {
  final String categoryId;

  final String name;

  final String? description;

  final double price;

  final String? image;

  final bool isAvailable;

  CreateMenuRequest({
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "categoryId": categoryId,
      "name": name,
      "description": description,
      "price": price,
      "image": image,
      "isAvailable": isAvailable,
    };
  }
}
