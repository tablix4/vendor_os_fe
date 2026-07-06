class UpdateMenuRequest {
  final String? categoryId;

  final String? name;

  final String? description;

  final double? price;

  final String? image;

  final bool? isAvailable;

  UpdateMenuRequest({
    this.categoryId,
    this.name,
    this.description,
    this.price,
    this.image,
    this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) "categoryId": categoryId,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (price != null) "price": price,
      if (image != null) "image": image,
      if (isAvailable != null) "isAvailable": isAvailable,
    };
  }
}
