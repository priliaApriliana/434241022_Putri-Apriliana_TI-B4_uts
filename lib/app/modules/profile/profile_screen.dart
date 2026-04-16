import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = controller.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? '?',
                      style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.name ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role.capitalize ?? '',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menu items
            _MenuItem(
              icon: Icons.person_outlined,
              title: 'Edit Profil',
              onTap: () => Get.snackbar('Info', 'Fitur dalam pengembangan',
                  snackPosition: SnackPosition.BOTTOM),
            ),
            _MenuItem(
              icon: Icons.lock_outlined,
              title: 'Ubah Password',
              onTap: () => Get.snackbar('Info', 'Fitur dalam pengembangan',
                  snackPosition: SnackPosition.BOTTOM),
            ),
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifikasi',
              onTap: () => Get.snackbar('Info', 'Fitur dalam pengembangan',
                  snackPosition: SnackPosition.BOTTOM),
            ),
            _DarkModeToggle(),
            const Divider(height: 1),
            _MenuItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              color: Colors.red,
              onTap: () => Get.dialog(
                AlertDialog(
                  title: const Text('Konfirmasi Logout'),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Batal')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: controller.logout,
                        child: const Text('Logout')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem(
      {required this.icon,
      required this.title,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.dark_mode_outlined),
      title: const Text('Dark Mode'),
      trailing: Switch(
        value: Get.isDarkMode,
        onChanged: (val) {
          Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
        },
      ),
    );
  }
}


