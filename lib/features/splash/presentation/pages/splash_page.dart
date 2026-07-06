import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/storage_service.dart';

import '../../../authentication/data/models/refresh_token_request.dart';
import '../../../authentication/data/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scale;

  late Animation<double> _fade;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scale = Tween<double>(
      begin: .7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fade = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final refreshToken = await StorageService.getRefreshToken();

    if (!mounted) return;

    if (refreshToken == null || refreshToken.isEmpty) {
      context.go("/login");
      return;
    }

    try {
      debugPrint("========== AUTO LOGIN ==========");
      debugPrint("Refreshing Access Token...");

      final response = await _authService.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      await StorageService.saveAccessToken(response.data.accessToken);

      await StorageService.saveRefreshToken(response.data.refreshToken);

      debugPrint("Refresh Success");

      if (!mounted) return;

      context.go("/dashboard");
    } catch (e) {
      debugPrint("Refresh Failed");

      await StorageService.clearAll();

      if (!mounted) return;

      context.go("/login");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff16A34A), Color(0xff0F766E)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -60,
              child: _circle(220, Colors.white10),
            ),

            Positioned(
              right: -40,
              bottom: -40,
              child: _circle(180, Colors.white12),
            ),

            Positioned(
              left: 50,
              bottom: 180,
              child: _circle(35, Colors.white24),
            ),

            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLogo(),

                      const SizedBox(height: 35),

                      const Text(
                        "TABLIX",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 42,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Restaurant Management",
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      ),

                      const SizedBox(height: 50),

                      Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color(0xff16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xff16A34A),
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const Icon(Icons.restaurant_menu, color: Colors.white, size: 34),
        ],
      ),
    );
  }
}
