import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/ticket_service.dart';

class DashboardController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _ticketService = Get.find<TicketService>();

  final stats = <String, int>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  void loadStats() {
    final user = _authService.currentUser.value;
    final userId = user?.isUser == true ? user?.id : null;
    stats.value = _ticketService.getStatistics(userId);
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
