import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../theme/app_theme.dart';
import 'ticket_controller.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TicketController>();
    final authService = Get.find<AuthService>();
    final ticketId = Get.arguments as String;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.loadTicketDetail(ticketId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tiket'),
        actions: [
          Obx(() {
            final user = authService.currentUser.value;
            if (user?.isHelpdesk != true) return const SizedBox.shrink();
            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'assign') {
                  _showAssignDialog(
                    context,
                    ctrl,
                    ticketId,
                    authService.assignableUsers,
                  );
                  return;
                }
                ctrl.updateStatus(ticketId, value);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'open', child: Text('Set: Open')),
                PopupMenuItem(
                    value: 'in_progress', child: Text('Set: In Progress')),
                PopupMenuItem(value: 'resolved', child: Text('Set: Resolved')),
                PopupMenuItem(value: 'closed', child: Text('Set: Closed')),
                PopupMenuDivider(),
                PopupMenuItem(value: 'assign', child: Text('Assign Tiket')),
              ],
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.more_vert),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final ticket = ctrl.selectedTicket.value;
        if (ticket == null) {
          return const Center(child: Text('Tiket tidak ditemukan'));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ticket.id,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _StatusBadge(ticket.status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ticket.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 8),
                            _InfoRow(Icons.category_outlined, 'Kategori', ticket.category),
                            const SizedBox(height: 8),
                            _InfoRow(
                              Icons.flag_outlined,
                              'Prioritas',
                              ticket.priority.capitalize ?? ticket.priority,
                              valueColor: AppTheme.priorityColor(ticket.priority),
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(Icons.person_outlined, 'Dilaporkan oleh', ticket.createdByName),
                            if (ticket.assignedToName != null) ...[
                              const SizedBox(height: 8),
                              _InfoRow(
                                Icons.assignment_ind_outlined,
                                'Ditangani oleh',
                                ticket.assignedToName!,
                              ),
                            ],
                            const SizedBox(height: 8),
                            _InfoRow(
                              Icons.calendar_today_outlined,
                              'Dibuat',
                              DateFormat('dd MMM yyyy, HH:mm').format(ticket.createdAt),
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              Icons.update_outlined,
                              'Diupdate',
                              DateFormat('dd MMM yyyy, HH:mm').format(ticket.updatedAt),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deskripsi',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Text(ticket.description, style: const TextStyle(height: 1.5)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TrackingTimeline(ticket.status),
                    const SizedBox(height: 16),
                    const Text(
                      'Komentar',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (ctrl.isLoadingComments.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (ctrl.comments.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text('Belum ada komentar')),
                        );
                      }
                      return Column(
                        children: ctrl.comments.map((comment) {
                          final isCurrentUser =
                              comment.userId == authService.currentUser.value?.id;
                          return Align(
                            alignment:
                                isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        comment.userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: isCurrentUser ? Colors.white : null,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          comment.userRole.capitalize ?? comment.userRole,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: isCurrentUser ? Colors.white70 : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    comment.content,
                                    style: TextStyle(
                                      color: isCurrentUser ? Colors.white : null,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (authService.currentUser.value?.isHelpdesk == true) ...[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () => ctrl.prepareReply(comment.userName),
                                        icon: const Icon(Icons.reply, size: 14),
                                        label: const Text('Balas'),
                                        style: TextButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          foregroundColor: isCurrentUser
                                              ? Colors.white
                                              : Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                  Text(
                                    DateFormat('HH:mm, dd MMM').format(comment.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isCurrentUser ? Colors.white60 : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl.commentCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Balas komentar atau tulis interaksi...',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => IconButton.filled(
                        onPressed: ctrl.isSubmitting.value
                            ? null
                            : () => ctrl.addComment(ticketId),
                        icon: ctrl.isSubmitting.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

Future<void> _showAssignDialog(
  BuildContext context,
  TicketController ctrl,
  String ticketId,
  List<UserModel> assignableUsers,
) async {
  if (assignableUsers.isEmpty) {
    Get.snackbar('Info', 'Belum ada user yang bisa di-assign');
    return;
  }

  var selectedUser = assignableUsers.first;
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Assign Tiket'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButtonFormField<UserModel>(
              initialValue: selectedUser,
              decoration: const InputDecoration(
                labelText: 'Pilih siapa yang handle tiket',
              ),
              items: [
                for (final user in assignableUsers)
                  DropdownMenuItem<UserModel>(
                    value: user,
                    child: Text('${user.name} (${user.role})'),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedUser = value);
                }
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await ctrl.assignTicket(
                ticketId,
                selectedUser.id,
                selectedUser.name,
              );
            },
            child: const Text('Assign'),
          ),
        ],
      );
    },
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.icon, this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.statusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.statusColor(status).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        AppTheme.statusLabel(status),
        style: TextStyle(
          color: AppTheme.statusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TrackingTimeline extends StatelessWidget {
  final String currentStatus;
  const _TrackingTimeline(this.currentStatus);

  @override
  Widget build(BuildContext context) {
    final steps = ['open', 'in_progress', 'resolved', 'closed'];
    final labels = ['Open', 'In Progress', 'Resolved', 'Closed'];
    final currentIdx = steps.indexOf(currentStatus);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(steps.length, (i) {
                final isDone = i <= currentIdx;
                final isActive = i == currentIdx;
                return Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isDone
                                  ? AppTheme.statusColor(steps[i])
                                  : Colors.grey[200],
                              shape: BoxShape.circle,
                              border: isActive
                                  ? Border.all(
                                      color: AppTheme.statusColor(steps[i]),
                                      width: 3,
                                    )
                                  : null,
                            ),
                            child: Icon(
                              isDone ? Icons.check : Icons.circle_outlined,
                              size: 16,
                              color: isDone ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.normal,
                              color: isDone
                                  ? AppTheme.statusColor(steps[i])
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (i < steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 20),
                            color: i < currentIdx ? Colors.green : Colors.grey[200],
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
