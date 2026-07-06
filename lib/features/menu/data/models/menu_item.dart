class MenuItemModel {
  final String id;
  final String categoryId;
  final String categoryName;

  final String name;
  final String? description;

  final double price;

  final String? image;

  final bool isAvailable;

  MenuItemModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.isAvailable,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final category = json["category"];

    String categoryName = "";

    if (category is Map<String, dynamic>) {
      categoryName = category["name"]?.toString() ?? "";
    } else if (json["categoryName"] != null) {
      categoryName = json["categoryName"].toString();
    }

    return MenuItemModel(
      id: json["id"]?.toString() ?? "",

      categoryId: json["categoryId"]?.toString() ?? "",

      categoryName: categoryName,

      name: json["name"]?.toString() ?? "",

      description: json["description"]?.toString(),

      price: double.tryParse(json["price"].toString()) ?? 0,

      image: json["image"]?.toString(),

      isAvailable: json["isAvailable"] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "categoryId": categoryId,
      "name": name,
      "description": description,
      "price": price,
      "image": image,
      "isAvailable": isAvailable,
    };
  }
}
