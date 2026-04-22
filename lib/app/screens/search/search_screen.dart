import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/search_controller.dart' show VaultSearchController;
import '../../models/account.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/code_text.dart';
import '../../widgets/service_avatar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = Get.find<VaultSearchController>();
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: _ctrl.query.value);
    _textCtrl.addListener(() => _ctrl.setQuery(_textCtrl.text));
    // Pre-fill with 'cloud' to match the design
    Future.microtask(() {
      _textCtrl.text = 'cloud';
      _ctrl.setQuery('cloud');
    });
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPad),
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              final results = _ctrl.results;
              final query = _ctrl.query.value;
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (query.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                      child: Text(
                        '${results.length} ${results.length == 1 ? 'match' : 'matches'}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    ...results.map((a) => _ResultRow(account: a, query: query)),
                  ],
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 18, 0, 10),
                    child: Text(
                      'RECENT SEARCHES',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.muted,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ctrl.recentSearches
                        .map((r) => _RecentChip(
                              label: r,
                              onTap: () {
                                _textCtrl.text = r;
                                _ctrl.selectRecent(r);
                              },
                            ))
                        .toList(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.blue, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: 0.08),
                    blurRadius: 0,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  const Icon(Icons.search, size: 16, color: AppColors.blue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.ink,
                      ),
                      cursorColor: AppColors.orange,
                      cursorWidth: 2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(color: AppColors.mutedSoft),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final Account account;
  final String query;

  const _ResultRow({required this.account, required this.query});

  @override
  Widget build(BuildContext context) {
    final nameLower = account.name.toLowerCase();
    final queryLower = query.toLowerCase();
    final matchStart = nameLower.indexOf(queryLower);
    final matchEnd = matchStart >= 0 ? matchStart + query.length : -1;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.codeDetail, arguments: account),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            ServiceAvatar(letter: account.name[0], color: account.color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HighlightedName(
                    name: account.name,
                    matchStart: matchStart,
                    matchEnd: matchEnd,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account.login,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            CodeText(code: account.code, fontSize: 18, letterSpacing: 1.2),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.mutedSoft),
          ],
        ),
      ),
    );
  }
}

class _HighlightedName extends StatelessWidget {
  final String name;
  final int matchStart;
  final int matchEnd;

  const _HighlightedName({
    required this.name,
    required this.matchStart,
    required this.matchEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (matchStart < 0) {
      return Text(
        name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        children: [
          if (matchStart > 0)
            TextSpan(text: name.substring(0, matchStart)),
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                name.substring(matchStart, matchEnd),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange,
                ),
              ),
            ),
          ),
          if (matchEnd < name.length)
            TextSpan(text: name.substring(matchEnd)),
        ],
      ),
    );
  }
}

class _RecentChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RecentChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.blueSoft,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, size: 12, color: AppColors.blue),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
