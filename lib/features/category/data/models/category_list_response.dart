import 'category_model.dart';

class CategoryListResponse {
  final bool success;
  final String message;
  final List<CategoryModel> data;

  const CategoryListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      success: json["success"],
      message: json["message"],
      data: (json["data"] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }
}
