import '../models/create_menu_request.dart';
import '../models/menu_item.dart';
import '../models/update_menu_request.dart';
import '../services/menu_service.dart';

class MenuRepository {
  final MenuService _service = MenuService();

  Future<List<MenuItemModel>> getMenuItems({
    String? search,
    String? categoryId,
    bool? isAvailable,
  }) {
    return _service.getMenuItems(
      search: search,
      categoryId: categoryId,
      isAvailable: isAvailable,
    );
  }

  Future<void> createMenu(CreateMenuRequest request) {
    return _service.createMenu(request);
  }

  Future<void> updateMenu(String id, UpdateMenuRequest request) {
    return _service.updateMenu(id, request);
  }

  Future<void> deleteMenu(String id) {
    return _service.deleteMenu(id);
  }

  Future<void> toggleAvailability(String id) {
    return _service.toggleAvailability(id);
  }
}
