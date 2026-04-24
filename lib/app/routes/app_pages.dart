import 'package:get/get.dart';
import '../controllers/add_account_controller.dart';
import '../controllers/vault_controller.dart';
import '../controllers/search_controller.dart' show VaultSearchController;
import '../screens/account_settings/account_settings_screen.dart';
import '../screens/add_account/add_account_screen.dart';
import '../screens/app_settings/app_settings_screen.dart';
import '../screens/code_detail/code_detail_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/lock/lock_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/vault/vault_screen.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.lock,
      page: () => const LockScreen(),
    ),
    GetPage(
      name: AppRoutes.vault,
      page: () => const VaultScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VaultController>(() => VaultController());
      }),
    ),
    GetPage(
      name: AppRoutes.codeDetail,
      page: () => const CodeDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.addAccount,
      page: () => const AddAccountScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddAccountController>(() => AddAccountController());
      }),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<VaultSearchController>(() => VaultSearchController());
      }),
    ),
    GetPage(
      name: AppRoutes.accountSettings,
      page: () => const AccountSettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const AppSettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryScreen(),
    ),
  ];
}
