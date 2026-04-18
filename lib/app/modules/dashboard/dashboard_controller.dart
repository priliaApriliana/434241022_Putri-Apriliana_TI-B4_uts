import 'package:get/get.dart';

import '../../data/services/auth_service.dart';
import '../../data/services/ticket_service.dart';

class DashboardController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _ticketService = Get.find<TicketService>();

  final stats = <String, int>{}.obs;
  final roleMetrics = <String, int>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    isLoading.value = true;
    try {
      final user = _authService.currentUser.value;
      final userId = user?.isUser == true ? user?.id : null;

      stats.value = _ticketService.getStatistics(userId);
      final tickets = await _ticketService.getTickets(userId: userId);

      if (user?.isUser == true) {
        roleMetrics.value = {
          'submitted': tickets.length,
          'ongoing': tickets.where((t) => t.status == 'in_progress').length,
          'finish': tickets.where((t) => t.status == 'closed').length,
        };
      } else {
        final activeTickets = tickets.where((t) => t.status != 'closed').length;
        final unhandledTickets = tickets
            .where(
              (t) =>
                  t.status == 'open' &&
                  (t.assignedTo == null || t.assignedTo!.trim().isEmpty),
            )
            .length;
        roleMetrics.value = {
          'ticket_in': activeTickets,
          'ongoing': tickets.where((t) => t.status == 'in_progress').length,
          'unhandled': unhandledTickets,
          'approved_finish': tickets.where((t) => t.status == 'closed').length,
          'total_incoming': tickets.length,
        };
      }
    } finally {
      isLoading.value = false;
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
