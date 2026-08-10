import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/pages/complete_profile_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/otp_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/menu/presentation/pages/add_menu_page.dart';
import '../../features/menu/presentation/pages/menu_page.dart';
import '../../features/order/presentation/pages/create_order_page.dart';
import '../../features/order/presentation/pages/order_details_page.dart';
import '../../features/order/presentation/pages/order_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../shell/main_shell_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    //--------------------------------------------------------------------------
    // Authentication
    //--------------------------------------------------------------------------
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),

    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    GoRoute(
      path: '/otp',
      builder: (context, state) {
        return OtpPage(email: state.extra as String);
      },
    ),

    GoRoute(
      path: '/complete-profile',
      builder: (context, state) => const CompleteProfilePage(),
    ),

    //--------------------------------------------------------------------------
    // Main Application
    //--------------------------------------------------------------------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellPage(navigationShell: navigationShell);
      },

      branches: [
        //----------------------------------------------------------------------
        // Dashboard
        //----------------------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) {
                return const DashboardPage();
              },
            ),
          ],
        ),

        //----------------------------------------------------------------------
        // Categories
        //----------------------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/categories',
              builder: (context, state) {
                return const CategoryPage();
              },
            ),
          ],
        ),

        //----------------------------------------------------------------------
        // Menu
        //----------------------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/menu',
              builder: (context, state) {
                return const MenuPage();
              },
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) {
                    return const AddMenuPage();
                  },
                ),
              ],
            ),
          ],
        ),

        //----------------------------------------------------------------------
        // Orders
        //----------------------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) {
                return const OrderPage();
              },
              routes: [
                GoRoute(
                  path: 'create',
                  builder: (context, state) {
                    return const CreateOrderPage();
                  },
                ),
                GoRoute(
                  path: ':orderId',
                  builder: (context, state) {
                    return OrderDetailsPage(
                      orderId: state.pathParameters['orderId']!,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        //----------------------------------------------------------------------
        // Profile
        //----------------------------------------------------------------------
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                // return const Scaffold(
                //   body: Center(child: Text('Profile Coming Soon')),
                // );
                return const ProfilePage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
