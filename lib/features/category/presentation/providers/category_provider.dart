import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/models/category_model.dart';
import '../../data/models/create_category_request.dart';
import '../../data/repositories/category_repository.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryModel>>>(
      (ref) => CategoryNotifier(),
    );

class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  CategoryNotifier() : super(const AsyncLoading()) {
    getCategories();
  }

  final CategoryRepository _repository = CategoryRepository();

  Future<void> getCategories() async {
    try {
      state = const AsyncLoading();

      final response = await _repository.getCategories();

      state = AsyncData(response.data);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> createCategory(String name) async {
    await _repository.createCategory(CreateCategoryRequest(name: name));

    await getCategories();
  }

  Future<void> updateCategory(String id, String name) async {
    await _repository.updateCategory(id, CreateCategoryRequest(name: name));

    await getCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.deleteCategory(id);

    await getCategories();
  }
}
