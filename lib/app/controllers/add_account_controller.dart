import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';
import 'app_controller.dart';

class AddAccountController extends GetxController {
  final nameCtrl = TextEditingController();
  final issuerCtrl = TextEditingController();
  final secretCtrl = TextEditingController();

  final nameError = RxnString();
  final secretError = RxnString();

  static final _base32 = RegExp(r'^[A-Z2-7]+=*$');

  static const _palette = [
    Color(0xFF0B1220),
    AppColors.orange,
    Color(0xFFA259FF),
    Color(0xFF232F3E),
    Color(0xFF37352F),
    Color(0xFF5E6AD2),
    Color(0xFF635BFF),
    Color(0xFF16A34A),
    Color(0xFFDC2626),
  ];

  bool submit() {
    final name = nameCtrl.text.trim();
    final raw = secretCtrl.text.trim().replaceAll(' ', '').toUpperCase();

    nameError.value = name.isEmpty ? 'Account name is required' : null;
    if (raw.isEmpty) {
      secretError.value = 'Secret key is required';
    } else if (!_base32.hasMatch(raw)) {
      secretError.value = 'Secret must be base32 (A–Z, 2–7)';
    } else {
      secretError.value = null;
    }

    if (nameError.value != null || secretError.value != null) return false;

    final issuer = issuerCtrl.text.trim();
    final displayName = issuer.isNotEmpty ? issuer : name;
    final login = issuer.isNotEmpty ? name : name;

    final app = Get.find<AppController>();
    final color = _palette[app.accounts.length % _palette.length];

    app.addAccount(Account(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: displayName,
      login: login,
      secretKey: raw,
      color: color,
      addedDate: DateTime.now(),
    ));

    reset();
    return true;
  }

  void reset() {
    nameCtrl.clear();
    issuerCtrl.clear();
    secretCtrl.clear();
    nameError.value = null;
    secretError.value = null;
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    issuerCtrl.dispose();
    secretCtrl.dispose();
    super.onClose();
  }
}
