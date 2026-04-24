import 'dart:async';
import 'package:get/get.dart';
import 'package:otp/otp.dart';
import '../models/account.dart';
import 'app_controller.dart';

class VaultController extends GetxController {
  final secondsRemaining = 30.obs;
  final selectedTabIndex = 0.obs;
  final liveCodes = <String, String>{}.obs;
  Timer? _timer;

  AppController get _app => Get.find<AppController>();

  List<Account> get accounts => _app.accounts;

  @override
  void onInit() {
    super.onInit();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    ever(_app.accounts, (_) => _rebuildCodes());
  }

  void _tick() {
    final now = DateTime.now();
    secondsRemaining.value = 30 - (now.second % 30);
    _rebuildCodes();
  }

  void _rebuildCodes() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final next = <String, String>{};
    for (final a in _app.accounts) {
      try {
        next[a.id] = OTP.generateTOTPCodeString(
          a.secretKey,
          now,
          length: 6,
          interval: 30,
          algorithm: Algorithm.SHA1,
          isGoogle: true,
        );
      } catch (_) {
        next[a.id] = '------';
      }
    }
    liveCodes.assignAll(next);
  }

  String codeFor(Account a) => liveCodes[a.id] ?? '------';

  double get t => secondsRemaining.value / 30.0;
  bool get isExpiring => secondsRemaining.value <= 6;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
