import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class DeleteCategoryDialog extends StatelessWidget {
  final VoidCallback onDelete;

  /// Optional: pass the category name to make the
  /// confirmation message clearer for the user.
  final String? categoryName;

  const DeleteCategoryDialog({
    super.key,
    required this.onDelete,
    this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    const dangerColor = Color(0xffDC2626);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // DELETE ICON
            // ==================================================
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: dangerColor.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: dangerColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: dangerColor,
                    size: 29,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ==================================================
            // TITLE
            // ==================================================
            Text(
              'Delete Category?',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                color: const Color(0xff0F172A),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // DESCRIPTION
            // ==================================================
            Text(
              categoryName != null && categoryName!.trim().isNotEmpty
                  ? 'Are you sure you want to delete "$categoryName"?'
                  : 'Are you sure you want to delete this category?',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xff64748B),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // WARNING
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: dangerColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: dangerColor.withValues(alpha: 0.12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: dangerColor,
                    size: 20,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'This action cannot be undone.',
                      style: AppTextStyles.small.copyWith(
                        color: dangerColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // ACTION BUTTONS
            // ==================================================
            Row(
              children: [
                // ------------------------------------------------
                // CANCEL
                // ------------------------------------------------
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff475569),
                        side: const BorderSide(color: Color(0xffE2E8F0)),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.button.copyWith(
                          color: const Color(0xff475569),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ------------------------------------------------
                // DELETE
                // ------------------------------------------------
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        onDelete();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: dangerColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.delete_outline_rounded, size: 20),

                          const SizedBox(width: 7),

                          Text(
                            'Delete Category',
                            style: AppTextStyles.button.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
