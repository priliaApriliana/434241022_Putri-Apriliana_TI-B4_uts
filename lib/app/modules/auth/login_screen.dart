import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: ctrl.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.support_agent_rounded,
                        size: 56, color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Selamat Datang!',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Login ke akun Anda',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                const SizedBox(height: 40),
                TextFormField(
                  controller: ctrl.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'contoh@email.com',
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email wajib diisi';
                    if (!v.isEmail) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                      controller: ctrl.passwordCtrl,
                      obscureText: ctrl.obscurePassword.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(ctrl.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => ctrl.obscurePassword.toggle(),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password wajib diisi';
                        if (v.length < 6) return 'Password minimal 6 karakter';
                        return null;
                      },
                    )),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.snackbar(
                      'Info', 'Hubungi admin untuk reset password',
                      snackPosition: SnackPosition.BOTTOM,
                    ),
                    child: const Text('Lupa Password?'),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: ctrl.isLoading.value ? null : ctrl.login,
                      child: ctrl.isLoading.value
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Login'),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () => Get.toNamed(Routes.register),
                      child: const Text('Daftar Sekarang'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Demo accounts helper
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Akun Demo',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      _demoAccountTile('Admin', 'admin@test.com', ctrl),
                      _demoAccountTile('Helpdesk', 'helpdesk@test.com', ctrl),
                      _demoAccountTile('User', 'user@test.com', ctrl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _demoAccountTile(String role, String email, AuthController ctrl) {
    return InkWell(
      onTap: () {
        ctrl.emailCtrl.text = email;
        ctrl.passwordCtrl.text = '123456';
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text('$role: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text(email, style: const TextStyle(fontSize: 12, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}

