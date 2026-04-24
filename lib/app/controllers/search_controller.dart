import 'package:get/get.dart';
import '../models/account.dart';
import 'app_controller.dart';

class VaultSearchController extends GetxController {
  final query = ''.obs;
  final recentSearches = ['github', 'aws', 'stripe'].obs;

  AppController get _app => Get.find<AppController>();

  List<Account> get results {
    if (query.value.isEmpty) return [];
    final q = query.value.toLowerCase();
    return _app.accounts
        .where((a) =>
            a.name.toLowerCase().contains(q) ||
            a.login.toLowerCase().contains(q))
        .toList();
  }

  void setQuery(String value) => query.value = value;

  void selectRecent(String term) {
    query.value = term;
  }
}
