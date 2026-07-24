import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/category/presentation/providers/category_provider.dart';
import '../../features/menu/presentation/providers/menu_provider.dart';
import '../../features/order/presentation/providers/order_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';

void resetUserSessionProviders(WidgetRef ref) {
  ref.invalidate(dashboardProvider);
  ref.invalidate(dashboardFilterProvider);

  ref.invalidate(categoryProvider);
  ref.invalidate(menuProvider);
  ref.invalidate(orderProvider);
  ref.invalidate(profileProvider);
}
