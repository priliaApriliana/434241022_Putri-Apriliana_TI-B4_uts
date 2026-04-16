import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _navigate());
  }

  Future<void> _navigate() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      
      // Use getIsRegistered to check if service is available
      if (!Get.isRegistered<AuthService>()) {
        // If not registered, register now
        Get.put(AuthService(), permanent: true);
      }
      
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      debugPrint('Error in splash navigation: ');
      Get.offAllNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.support_agent_rounded,
                  size: 72, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('E-Ticketing Helpdesk',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                )),
            const SizedBox(height: 8),
            Text('Universitas Airlangga',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                )),
            const SizedBox(height: 60),
            const CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

