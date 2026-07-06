import 'package:flutter/material.dart';

import 'router/app_router.dart';

class VendorOSApp extends StatelessWidget {
  const VendorOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Vendor OS",
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}