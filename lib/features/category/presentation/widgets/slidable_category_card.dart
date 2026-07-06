import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/category_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'slidable_action_button.dart';

class SlidableCategoryCard extends StatelessWidget {
  final CategoryModel category;

  final VoidCallback onEdit;

  final VoidCallback onDelete;

  const SlidableCategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
          key: ValueKey(category.id),

          startActionPane: ActionPane(
            extentRatio: .30,
            motion: const StretchMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (_) {
                  onEdit();
                },

                child: SlidableActionButton(
                  icon: Icons.edit_rounded,
                  title: "Edit",
                  color: const Color(0xff16A34A),
                  onTap: onEdit,
                ),
              ),
            ],
          ),

          endActionPane: ActionPane(
            extentRatio: .30,
            motion: const StretchMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (_) {
                  onDelete();
                },

                child: SlidableActionButton(
                  icon: Icons.delete_forever_rounded,
                  title: "Delete",
                  color: Colors.red,
                  onTap: onDelete,
                ),
              ),
            ],
          ),

          child: Card(
            margin: const EdgeInsets.only(bottom: 18),

            elevation: 3,

            color: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),

              side: BorderSide(color: Colors.grey.shade200),
            ),

            child: Padding(
              padding: const EdgeInsets.all(22),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,

                        height: 60,

                        decoration: BoxDecoration(
                          color: const Color(0xff16A34A).withOpacity(.12),

                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: const Icon(
                          Icons.fastfood_rounded,

                          color: Color(0xff16A34A),

                          size: 34,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              category.name,

                              style: const TextStyle(
                                fontSize: 22,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${category.itemCount} Items",

                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Divider(color: Colors.grey.shade200),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.grey.shade500,
                        size: 18,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        DateFormat(
                          "dd MMM yyyy • hh:mm a",
                        ).format(category.updatedAt),

                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: .25, end: 0, curve: Curves.easeOut)
        .scale(begin: const Offset(.95, .95), end: const Offset(1, 1));
  }
}
