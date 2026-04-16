import 'package:get/get.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/auth/auth_controller.dart';
import '../modules/dashboard/dashboard_screen.dart';
import '../modules/dashboard/dashboard_controller.dart';
import '../modules/ticket/ticket_list_screen.dart';
import '../modules/ticket/ticket_detail_screen.dart';
import '../modules/ticket/create_ticket_screen.dart';
import '../modules/ticket/ticket_controller.dart';
import '../modules/profile/profile_screen.dart';
import '../modules/profile/profile_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() { Get.put(AuthController()); }),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      binding: BindingsBuilder(() { Get.put(AuthController()); }),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController());
        Get.put(TicketController());
      }),
    ),
    GetPage(
      name: Routes.ticketList,
      page: () => const TicketListScreen(),
      binding: BindingsBuilder(() { Get.put(TicketController()); }),
    ),
    GetPage(
      name: Routes.ticketDetail,
      page: () => const TicketDetailScreen(),
    ),
    GetPage(
      name: Routes.ticketCreate,
      page: () => const CreateTicketScreen(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: BindingsBuilder(() { Get.lazyPut(() => ProfileController(), fenix: true); }),
    ),
  ];
}



