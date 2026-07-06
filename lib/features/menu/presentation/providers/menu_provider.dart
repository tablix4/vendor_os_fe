import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/create_menu_request.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/update_menu_request.dart';
import '../../data/repositories/menu_repository.dart';

final menuProvider = AsyncNotifierProvider<MenuNotifier, List<MenuItemModel>>(
  MenuNotifier.new,
);

class MenuNotifier extends AsyncNotifier<List<MenuItemModel>> {
  final MenuRepository _repository = MenuRepository();

  String _search = "";

  String? _categoryId;

  bool? _isAvailable;

  @override
  Future<List<MenuItemModel>> build() async {
    return getMenuItems();
  }

  Future<List<MenuItemModel>> getMenuItems() async {
    final items = await _repository.getMenuItems(
      search: _search,
      categoryId: _categoryId,
      isAvailable: _isAvailable,
    );

    state = AsyncData(items);

    return items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = AsyncData(await getMenuItems());
  }

  Future<void> search(String value) async {
    _search = value;

    await refresh();
  }

  Future<void> filterCategory(String? categoryId) async {
    _categoryId = categoryId;

    await refresh();
  }

  Future<void> filterAvailability(bool? value) async {
    _isAvailable = value;

    await refresh();
  }

  Future<void> createMenu(CreateMenuRequest request) async {
    await _repository.createMenu(request);

    await refresh();
  }

  Future<void> updateMenu(String id, UpdateMenuRequest request) async {
    await _repository.updateMenu(id, request);

    await refresh();
  }

  Future<void> deleteMenu(String id) async {
    await _repository.deleteMenu(id);

    await refresh();
  }

  Future<void> toggleAvailability(String id) async {
    await _repository.toggleAvailability(id);

    await refresh();
  }
}
