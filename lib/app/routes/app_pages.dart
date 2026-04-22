import 'package:get/get.dart';
import '../controllers/vault_controller.dart';
import '../controllers/search_controller.dart' show VaultSearchController;
import '../screens/vault/vault_screen.dart';
import '../screens/code_detail/code_detail_screen.dart';
import '../screens/add_account/add_account_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/account_settings/account_settings_screen.dart';
import '../screens/app_settings/app_settings_screen.dart';
import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
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
  ];
}
