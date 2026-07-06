import '../models/category_list_response.dart';
import '../models/category_response.dart';
import '../models/create_category_request.dart';

import '../services/category_service.dart';

class CategoryRepository {
  final CategoryService _service = CategoryService();

  Future<CategoryListResponse> getCategories() {
    return _service.getCategories();
  }

  Future<CategoryResponse> createCategory(CreateCategoryRequest request) {
    return _service.createCategory(request);
  }

  Future<CategoryResponse> updateCategory(
    String id,
    CreateCategoryRequest request,
  ) {
    return _service.updateCategory(id, request);
  }

  Future<void> deleteCategory(String id) {
    return _service.deleteCategory(id);
  }
}
