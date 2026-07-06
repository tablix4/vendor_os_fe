import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/category_provider.dart';
import '../widgets/category_header.dart';
import '../widgets/category_search.dart';
import '../widgets/slidable_category_card.dart';
import '../widgets/empty_category.dart';
import '../widgets/add_category_dialog.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final searchController = TextEditingController();

  String search = "";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: const Color(0xffF8FAFC),
        title: const Text(
          "Category Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),

      body: categories.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (items) {
          final filtered = items.where((e) {
            return e.name.toLowerCase().contains(search.toLowerCase());
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(categoryProvider.notifier).getCategories();
            },

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.only(bottom: 120),

              children: [
                CategoryHeader(
                  totalCategories: items.length,

                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AddCategoryDialog(
                          onSave: (name) {
                            return ref
                                .read(categoryProvider.notifier)
                                .createCategory(name);
                          },
                        );
                      },
                    );
                  },
                ),

                CategorySearch(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      search = value;
                    });
                  },
                ),

                const SizedBox(height: 30),

                if (filtered.isEmpty)
                  SizedBox(
                    height: 400,
                    child: EmptyCategory(
                      onAdd: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AddCategoryDialog(
                              onSave: (name) {
                                return ref
                                    .read(categoryProvider.notifier)
                                    .createCategory(name);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                ...filtered.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: SlidableCategoryCard(
                      category: category,

                      onEdit: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AddCategoryDialog(
                              initialValue: category.name,
                              title: "Update Category",
                              buttonText: "Update",
                              onSave: (name) {
                                return ref
                                    .read(categoryProvider.notifier)
                                    .updateCategory(category.id, name);
                              },
                            );
                          },
                        );
                      },

                      onDelete: () async {
                        final delete = await showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text("Delete Category"),

                              content: Text(
                                "Are you sure you want to delete '${category.name}' ?",
                              ),

                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Cancel"),
                                ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );

                        if (delete == true) {
                          await ref
                              .read(categoryProvider.notifier)
                              .deleteCategory(category.id);
                        }
                      },
                    ),
                  );
                }),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff16A34A),

        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return AddCategoryDialog(
                onSave: (name) {
                  return ref
                      .read(categoryProvider.notifier)
                      .createCategory(name);
                },
              );
            },
          );
        },

        icon: const Icon(Icons.add),

        label: const Text("Add Category"),
      ),
    );
  }
}
