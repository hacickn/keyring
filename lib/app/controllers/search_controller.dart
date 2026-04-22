import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account.dart';
import '../theme/app_theme.dart';

class VaultSearchController extends GetxController {
  final query = ''.obs;
  final recentSearches = ['github', 'aws', 'stripe'].obs;

  final _allAccounts = <Account>[
    const Account(id: '1', name: 'GitHub',     login: 'riley.ng',           code: '438210', color: Color(0xFF0B1220)),
    const Account(id: '2', name: 'Cloudflare', login: 'riley@fastmail.com', code: '029517', color: AppColors.orange),
    const Account(id: '3', name: 'Figma',      login: 'riley.ng',           code: '916044', color: Color(0xFFA259FF)),
    const Account(id: '4', name: 'AWS Root',   login: 'r.ng+aws',           code: '774902', color: Color(0xFF232F3E)),
    const Account(id: '5', name: 'Notion',     login: 'riley@fastmail.com', code: '308661', color: Color(0xFF37352F)),
    const Account(id: '6', name: 'Linear',     login: 'riley',              code: '521089', color: Color(0xFF5E6AD2)),
    const Account(id: '7', name: 'Stripe',     login: 'acct_live_N4k',      code: '680135', color: Color(0xFF635BFF)),
  ];

  List<Account> get results {
    if (query.value.isEmpty) return [];
    final q = query.value.toLowerCase();
    return _allAccounts
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
