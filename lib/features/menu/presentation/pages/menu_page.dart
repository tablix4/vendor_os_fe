import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../category/presentation/providers/category_provider.dart';

import '../providers/menu_provider.dart';

import '../widgets/add_menu_dialog.dart';
import '../widgets/menu_card.dart';
import '../widgets/menu_empty.dart';
import '../widgets/menu_filter_bar.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_search.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  final TextEditingController searchController = TextEditingController();

  String search = "";

  String? selectedCategoryId;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menus = ref.watch(menuProvider);

    final categories = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xffF8FAFC),
        title: const Text(
          "Menu Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: menus.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (items) {
          final filteredMenus = items.where((menu) {
            final searchMatch = menu.name.toLowerCase().contains(
              search.toLowerCase(),
            );

            final categoryMatch = selectedCategoryId == null
                ? true
                : menu.categoryId == selectedCategoryId;

            return searchMatch && categoryMatch;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(menuProvider.notifier).refresh();
            },

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                MenuHeader(
                  totalItems: items.length,
                  availableItems: items.where((e) => e.isAvailable).length,
                  unavailableItems: items.where((e) => !e.isAvailable).length,
                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddMenuDialog(),
                    );
                  },
                ),

                MenuSearch(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                categories.when(
                  loading: () => const SizedBox(),

                  error: (_, __) => const SizedBox(),

                  data: (list) {
                    return MenuFilterBar(
                      categories: list,
                      selectedCategoryId: selectedCategoryId,
                      onCategorySelected: (id) {
                        setState(() {
                          selectedCategoryId = id;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                if (filteredMenus.isEmpty)
                  SizedBox(
                    height: 400,
                    child: MenuEmpty(
                      onAdd: () {
                        showDialog(
                          context: context,
                          builder: (_) => const AddMenuDialog(),
                        );
                      },
                    ),
                  ),

                ...filteredMenus.map(
                  (menu) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: MenuCard(
                      menu: menu,

                      onEdit: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddMenuDialog(menu: menu),
                        );
                      },

                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text("Delete Menu"),
                            content: Text(
                              "Are you sure you want to delete '${menu.name}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(false);
                                },
                                child: const Text("Cancel"),
                              ),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(true);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await ref
                              .read(menuProvider.notifier)
                              .deleteMenu(menu.id);
                        }
                      },

                      onAvailabilityChanged: (_) async {
                        await ref
                            .read(menuProvider.notifier)
                            .toggleAvailability(menu.id);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff16A34A),
        onPressed: () {
          showDialog(context: context, builder: (_) => const AddMenuDialog());
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Menu"),
      ),
    );
  }
}
