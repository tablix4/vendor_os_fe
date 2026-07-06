import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

import '../models/category_list_response.dart';
import '../models/category_response.dart';
import '../models/create_category_request.dart';

class CategoryService {
  Future<CategoryListResponse> getCategories() async {
    final Response response = await ApiClient.dio.get(ApiConstants.categories);

    return CategoryListResponse.fromJson(response.data);
  }

  Future<CategoryResponse> createCategory(CreateCategoryRequest request) async {
    final Response response = await ApiClient.dio.post(
      ApiConstants.categories,
      data: request.toJson(),
    );

    return CategoryResponse.fromJson(response.data);
  }

  Future<CategoryResponse> updateCategory(
    String id,
    CreateCategoryRequest request,
  ) async {
    final Response response = await ApiClient.dio.patch(
      "${ApiConstants.categories}/$id",
      data: request.toJson(),
    );

    return CategoryResponse.fromJson(response.data);
  }

  Future<void> deleteCategory(String id) async {
    await ApiClient.dio.delete("${ApiConstants.categories}/$id");
  }
}
