class CategoryModel {
  final String id;

  final String name;

  final DateTime createdAt;

  final DateTime updatedAt;

  final int menuItemCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.menuItemCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),

      // Backend doesn't return this yet
      menuItemCount: json["menuItemCount"] ?? 0,
    );
  }
}
