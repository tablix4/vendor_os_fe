import 'category_model.dart';

class CategoryResponse {
  final bool success;
  final String message;
  final CategoryModel data;

  const CategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json["success"],
      message: json["message"],
      data: CategoryModel.fromJson(json["data"]),
    );
  }
}
