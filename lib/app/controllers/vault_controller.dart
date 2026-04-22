import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';

class VaultController extends GetxController {
  final secondsRemaining = 30.obs;
  final selectedTabIndex = 0.obs;
  Timer? _timer;

  final accounts = <Account>[
    const Account(id: '1', name: 'GitHub',     login: 'riley.ng',           code: '438210', color: Color(0xFF0B1220)),
    const Account(id: '2', name: 'Cloudflare', login: 'riley@fastmail.com', code: '029517', color: AppColors.orange),
    const Account(id: '3', name: 'Figma',      login: 'riley.ng',           code: '916044', color: Color(0xFFA259FF)),
    const Account(id: '4', name: 'AWS Root',   login: 'r.ng+aws',           code: '774902', color: Color(0xFF232F3E)),
    const Account(id: '5', name: 'Notion',     login: 'riley@fastmail.com', code: '308661', color: Color(0xFF37352F)),
    const Account(id: '6', name: 'Linear',     login: 'riley',              code: '521089', color: Color(0xFF5E6AD2)),
    const Account(id: '7', name: 'Stripe',     login: 'acct_live_N4k',      code: '680135', color: Color(0xFF635BFF)),
  ];

  @override
  void onInit() {
    super.onInit();
    _syncTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _syncTimer());
  }

  void _syncTimer() {
    final now = DateTime.now();
    secondsRemaining.value = 30 - (now.second % 30);
  }

  double get t => secondsRemaining.value / 30.0;
  bool get isExpiring => secondsRemaining.value <= 6;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
