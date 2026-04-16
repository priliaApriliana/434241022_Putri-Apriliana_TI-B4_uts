import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: ctrl.registerFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buat Akun Baru',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Isi data di bawah untuk mendaftar',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
              const SizedBox(height: 32),
              TextFormField(
                controller: ctrl.nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ctrl.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
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
                      if (v.length < 6) return 'Minimal 6 karakter';
                      return null;
                    },
                  )),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    controller: ctrl.confirmPasswordCtrl,
                    obscureText: ctrl.obscureConfirmPassword.value,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(ctrl.obscureConfirmPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => ctrl.obscureConfirmPassword.toggle(),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Konfirmasi password wajib diisi' : null,
                  )),
              const SizedBox(height: 32),
              Obx(() => ElevatedButton(
                    onPressed: ctrl.isLoading.value ? null : ctrl.register,
                    child: ctrl.isLoading.value
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Daftar'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

