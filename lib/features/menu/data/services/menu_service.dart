import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';

import '../models/create_menu_request.dart';
import '../models/menu_item.dart';
import '../models/update_menu_request.dart';

class MenuService {
  final Dio _dio = ApiClient.dio;

  Future<List<MenuItemModel>> getMenuItems({
    String? search,
    String? categoryId,
    bool? isAvailable,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.menuItems,
      queryParameters: {
        "page": page,
        "limit": limit,
        if (search != null && search.isNotEmpty) "search": search,
        if (categoryId != null) "categoryId": categoryId,
        if (isAvailable != null) "isAvailable": isAvailable,
      },
    );

    final List items = response.data["data"]["items"];

    return items.map((e) => MenuItemModel.fromJson(e)).toList();
  }

  Future<void> createMenu(CreateMenuRequest request) async {
    await _dio.post(ApiConstants.menuItems, data: request.toJson());
  }

  Future<void> updateMenu(String id, UpdateMenuRequest request) async {
    await _dio.patch("${ApiConstants.menuItems}/$id", data: request.toJson());
  }

  Future<void> deleteMenu(String id) async {
    await _dio.delete("${ApiConstants.menuItems}/$id");
  }

  Future<void> toggleAvailability(String id) async {
    await _dio.patch("${ApiConstants.menuItems}/$id/toggle");
  }
}
