import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../ticket/ticket_controller.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashCtrl = Get.find<DashboardController>();
    final authService = Get.find<AuthService>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ',',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Obx(() => Text(
                        authService.currentUser.value?.name ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(height: 4),
                  Obx(() {
                    final role = authService.currentUser.value?.role ?? '';
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role.isNotEmpty ? (role[0].toUpperCase() + role.substring(1)) : role,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Stat cards row
                  Obx(() => Row(
                        children: [
                          _StatCard(
                              label: 'Total',
                              value: dashCtrl.stats['total'] ?? 0,
                              color: Colors.white),
                          const SizedBox(width: 10),
                          _StatCard(
                              label: 'Open',
                              value: dashCtrl.stats['open'] ?? 0,
                              color: Colors.orange[200]!),
                          const SizedBox(width: 10),
                          _StatCard(
                              label: 'Proses',
                              value: dashCtrl.stats['in_progress'] ?? 0,
                              color: Colors.blue[200]!),
                          const SizedBox(width: 10),
                          _StatCard(
                              label: 'Selesai',
                              value: dashCtrl.stats['resolved'] ?? 0,
                              color: Colors.green[200]!),
                        ],
                      )),
                ],
              ),
            ),
            // Recent tickets
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tiket Terbaru',
                            style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => Get.toNamed(Routes.ticketList),
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(child: _RecentTicketsList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
      floatingActionButton: Obx(() {
        final user = authService.currentUser.value;
        if (user?.isUser != true) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () => Get.toNamed(Routes.ticketCreate),
          icon: const Icon(Icons.add),
          label: const Text('Buat Tiket'),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(value.toString(),
                style: TextStyle(
                    color: color == Colors.white ? Colors.white : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _RecentTicketsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TicketController>();
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final recent = ctrl.tickets.take(5).toList();
      if (recent.isEmpty) {
        return const Center(child: Text('Belum ada tiket'));
      }
      return ListView.separated(
        itemCount: recent.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final ticket = recent[i];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor:
                    AppTheme.statusColor(ticket.status).withValues(alpha: 0.15),
                child: Icon(Icons.confirmation_number_outlined,
                    color: AppTheme.statusColor(ticket.status), size: 20),
              ),
              title: Text(ticket.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(ticket.category,
                  style: const TextStyle(fontSize: 12)),
              trailing: _StatusBadge(ticket.status),
              onTap: () => Get.toNamed(Routes.ticketDetail,
                  arguments: ticket.id),
            ),
          );
        },
      );
    });
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.statusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.statusColor(status).withValues(alpha: 0.4)),
      ),
      child: Text(
        AppTheme.statusLabel(status),
        style: TextStyle(
          color: AppTheme.statusColor(status),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final _index = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => NavigationBar(
          selectedIndex: _index.value,
          onDestinationSelected: (i) {
            _index.value = i;
            if (i == 1) Get.toNamed(Routes.ticketList);
            if (i == 2) Get.toNamed(Routes.profile);
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: 'Tiket'),
            NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: 'Profil'),
          ],
        ));
  }
}
