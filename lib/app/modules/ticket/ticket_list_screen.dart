import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ticket_controller.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TicketController>();
    final authService = Get.find<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tiket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: ctrl.loadTickets,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Obx(() => Row(
                  children: [
                    for (final filter in [
                      ('all', 'Semua'),
                      ('open', 'Open'),
                      ('in_progress', 'In Progress'),
                      ('resolved', 'Resolved'),
                      ('closed', 'Closed'),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter.$2),
                          selected: ctrl.selectedFilter.value == filter.$1,
                          onSelected: (_) => ctrl.setFilter(filter.$1),
                        ),
                      ),
                  ],
                )),
          ),
          // List
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _SkeletonCard(),
                );
              }
              if (ctrl.tickets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.3)),
                      const SizedBox(height: 16),
                      const Text('Tidak ada tiket',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: ctrl.loadTickets,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.tickets.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final ticket = ctrl.tickets[i];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Get.toNamed(Routes.ticketDetail,
                            arguments: ticket.id),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ticket.id,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w600)),
                                  _StatusBadge(ticket.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(ticket.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(ticket.description,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _PriorityBadge(ticket.priority),
                                  const SizedBox(width: 8),
                                  Icon(Icons.folder_outlined,
                                      size: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5)),
                                  const SizedBox(width: 4),
                                  Text(ticket.category,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.6))),
                                  const Spacer(),
                                  Icon(Icons.access_time,
                                      size: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.4)),
                                  const SizedBox(width: 4),
                                  Text(
                                      timeago.format(ticket.createdAt,
                                          locale: 'id'),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5))),
                                ],
                              ),
                              if (ticket.assignedToName != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.person_pin_outlined,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('Ditangani: ${ticket.assignedToName}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                              if (ticket.commentCount > 0) ...[
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.comment_outlined,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('${ticket.commentCount} komentar',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ]),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final user = authService.currentUser.value;
        if (user?.isUser != true) return const SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ticketCreate),
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.statusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AppTheme.statusColor(status).withValues(alpha: 0.4)),
      ),
      child: Text(AppTheme.statusLabel(status),
          style: TextStyle(
              color: AppTheme.statusColor(status),
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge(this.priority);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.priorityColor(priority).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(priority.capitalize ?? priority,
          style: TextStyle(
              color: AppTheme.priorityColor(priority),
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
    );
  }
}


