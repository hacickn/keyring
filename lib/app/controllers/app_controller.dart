import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account.dart';
import '../models/copy_event.dart';
import '../models/sync_state.dart';
import '../theme/app_theme.dart';

class AppController extends GetxController {
  final accounts = <Account>[].obs;
  final copyHistory = <CopyEvent>[].obs;
  final syncState = SyncState.synced.obs;
  final lastSyncedAt = Rx<DateTime?>(DateTime.now());
  final iCloudEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _seedAccounts();
  }

  void _seedAccounts() {
    final seed = DateTime(2026, 3, 12);
    accounts.assignAll([
      Account(id: '1', name: 'GitHub',     login: 'riley.ng',           secretKey: 'JBSWY3DPEHPK3PXP', color: const Color(0xFF0B1220), addedDate: seed),
      Account(id: '2', name: 'Cloudflare', login: 'riley@fastmail.com', secretKey: 'KZXW6YTBOI======', color: AppColors.orange,        addedDate: seed),
      Account(id: '3', name: 'Figma',      login: 'riley.ng',           secretKey: 'MFRGG2LTMVZA====', color: const Color(0xFFA259FF), addedDate: seed),
      Account(id: '4', name: 'AWS Root',   login: 'r.ng+aws',           secretKey: 'ONSWG4TFORZA====', color: const Color(0xFF232F3E), addedDate: seed),
      Account(id: '5', name: 'Notion',     login: 'riley@fastmail.com', secretKey: 'PFXXK4DBMVZA====', color: const Color(0xFF37352F), addedDate: seed),
      Account(id: '6', name: 'Linear',     login: 'riley',              secretKey: 'NRSWG5LTMVRXEZLU', color: const Color(0xFF5E6AD2), addedDate: seed),
      Account(id: '7', name: 'Stripe',     login: 'acct_live_N4k',      secretKey: 'OZSXE6LFOQQHEYLT', color: const Color(0xFF635BFF), addedDate: seed),
    ]);
  }

  void addAccount(Account a) {
    accounts.add(a);
    _mockSync();
  }

  void removeAccount(String id) {
    accounts.removeWhere((a) => a.id == id);
    _mockSync();
  }

  void updateAccount(Account updated) {
    final i = accounts.indexWhere((a) => a.id == updated.id);
    if (i != -1) {
      accounts[i] = updated;
      _mockSync();
    }
  }

  void recordCopy(Account a, String code) {
    copyHistory.insert(0, CopyEvent(account: a, code: code, time: DateTime.now()));
  }

  void toggleICloud(bool enabled) {
    iCloudEnabled.value = enabled;
    if (enabled) _mockSync();
  }

  Future<void> _mockSync() async {
    if (!iCloudEnabled.value) return;
    syncState.value = SyncState.syncing;
    await Future.delayed(const Duration(milliseconds: 900));
    syncState.value = SyncState.synced;
    lastSyncedAt.value = DateTime.now();
  }
}
