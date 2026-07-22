import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class VendorOSApp extends StatelessWidget {
  const VendorOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Vendor OS",
      debugShowCheckedModeBanner: false,
      // Apply the app's global theme
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}