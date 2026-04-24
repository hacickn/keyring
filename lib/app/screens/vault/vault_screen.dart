import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/vault_controller.dart';
import '../../models/account.dart';
import '../../models/sync_state.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/code_text.dart';
import '../../widgets/service_avatar.dart';
import '../../widgets/timer_ring.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<VaultController>();
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _Header(topPad: topPad, ctrl: ctrl),
          Expanded(
            child: Obx(() {
              final t = ctrl.t;
              final expiring = ctrl.isExpiring;
              final accounts = ctrl.accounts;
              if (accounts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'No accounts yet.\nTap + to add one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.muted, height: 1.5),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                itemCount: accounts.length,
                itemBuilder: (context, i) {
                  final account = accounts[i];
                  final code = ctrl.liveCodes[account.id] ?? '------';
                  return _AccountRow(
                    account: account,
                    code: code,
                    t: t,
                    expiring: expiring,
                  );
                },
              );
            }),
          ),
          Obx(() => _BottomTabBar(selectedIndex: ctrl.selectedTabIndex.value)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double topPad;
  final VaultController ctrl;

  const _Header({required this.topPad, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: EdgeInsets.fromLTRB(20, topPad + 12, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KEYRING',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Codes',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _IconButton(
                    onTap: () => Get.toNamed(AppRoutes.search),
                    child: const Icon(Icons.search, size: 18, color: AppColors.ink),
                  ),
                  const SizedBox(width: 10),
                  _IconButton(
                    color: AppColors.blue,
                    shadow: true,
                    onTap: () => Get.toNamed(AppRoutes.addAccount),
                    child: const Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Obx(() => _TimerStrip(seconds: ctrl.secondsRemaining.value, t: ctrl.t)),
        ],
      ),
    );
  }
}

class _TimerStrip extends StatelessWidget {
  final int seconds;
  final double t;

  const _TimerStrip({required this.seconds, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          TimerRing(t: t, size: 28, strokeWidth: 3.5),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppColors.ink),
                children: [
                  const TextSpan(text: 'Codes refresh in '),
                  TextSpan(
                    text: '${seconds}s',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _SyncBadge(),
        ],
      ),
    );
  }
}

class _SyncBadge extends StatelessWidget {
  const _SyncBadge();

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    return Obx(() {
      String label;
      Color bg;
      Color fg;
      if (!app.iCloudEnabled.value) {
        label = 'LOCAL';
        bg = AppColors.line;
        fg = AppColors.muted;
      } else {
        switch (app.syncState.value) {
          case SyncState.syncing:
            label = 'SYNCING';
            bg = AppColors.orangeSoft;
            fg = AppColors.orange;
            break;
          case SyncState.error:
            label = 'ERROR';
            bg = AppColors.orangeSoft;
            fg = AppColors.orange;
            break;
          case SyncState.synced:
            label = 'SYNCED';
            bg = AppColors.blueSoft;
            fg = AppColors.blue;
            break;
        }
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: fg,
            letterSpacing: 0.3,
          ),
        ),
      );
    });
  }
}

class _AccountRow extends StatelessWidget {
  final Account account;
  final String code;
  final double t;
  final bool expiring;

  const _AccountRow({
    required this.account,
    required this.code,
    required this.t,
    required this.expiring,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.codeDetail, arguments: account),
      onLongPress: () =>
          Get.toNamed(AppRoutes.accountSettings, arguments: account),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: expiring ? AppColors.orangeSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: expiring
                ? AppColors.orange.withValues(alpha: 0.2)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            ServiceAvatar(letter: account.name[0], color: account.color),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    account.login,
                    style: const TextStyle(fontSize: 12, color: AppColors.muted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            CodeText(
              code: code,
              fontSize: 22,
              letterSpacing: 1.5,
              color: expiring ? AppColors.orange : AppColors.ink,
            ),
            const SizedBox(width: 10),
            TimerRing(t: t, size: 24),
          ],
        ),
      ),
    );
  }
}

class _BottomTabBar extends StatelessWidget {
  final int selectedIndex;

  const _BottomTabBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final ctrl = Get.find<VaultController>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad + 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TabItem(
            label: 'Codes',
            active: selectedIndex == 0,
            icon: _CodesIcon(active: selectedIndex == 0),
            onTap: () => ctrl.selectedTabIndex.value = 0,
          ),
          _TabItem(
            label: 'History',
            active: selectedIndex == 1,
            icon: _HistoryIcon(active: selectedIndex == 1),
            onTap: () {
              ctrl.selectedTabIndex.value = 1;
              Get.toNamed(AppRoutes.history)?.then(
                (_) => ctrl.selectedTabIndex.value = 0,
              );
            },
          ),
          _TabItem(
            label: 'Settings',
            active: selectedIndex == 2,
            icon: _SettingsIcon(active: selectedIndex == 2),
            onTap: () {
              ctrl.selectedTabIndex.value = 2;
              Get.toNamed(AppRoutes.settings)?.then(
                (_) => ctrl.selectedTabIndex.value = 0,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final Widget icon;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.active,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: active ? AppColors.blueSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: active ? AppColors.blue : AppColors.mutedSoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool shadow;
  final VoidCallback? onTap;

  const _IconButton({
    required this.child,
    this.color = AppColors.surface,
    this.shadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: shadow ? null : Border.all(color: AppColors.line),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

// Tab icons
class _CodesIcon extends StatelessWidget {
  final bool active;
  const _CodesIcon({required this.active});
  @override
  Widget build(BuildContext context) {
    final c = active ? AppColors.blue : AppColors.mutedSoft;
    return CustomPaint(painter: _CodesIconPainter(color: c), size: const Size(16, 16));
  }
}

class _CodesIconPainter extends CustomPainter {
  final Color color;
  _CodesIconPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final rrect = RRect.fromLTRBR(1.5, 3, 14.5, 13, const Radius.circular(2));
    canvas.drawRRect(rrect, p);
    canvas.drawLine(const Offset(4, 6.5), const Offset(7, 6.5), p);
    canvas.drawLine(const Offset(4, 9), const Offset(9, 9), p);
  }
  @override
  bool shouldRepaint(_CodesIconPainter old) => old.color != color;
}

class _HistoryIcon extends StatelessWidget {
  final bool active;
  const _HistoryIcon({required this.active});
  @override
  Widget build(BuildContext context) {
    final c = active ? AppColors.blue : AppColors.mutedSoft;
    return CustomPaint(painter: _HistoryIconPainter(color: c), size: const Size(16, 16));
  }
}

class _HistoryIconPainter extends CustomPainter {
  final Color color;
  _HistoryIconPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(const Offset(8, 8), 6.2, p);
    final path = Path()
      ..moveTo(8, 4.5)
      ..lineTo(8, 8)
      ..lineTo(10.5, 9.5);
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(_HistoryIconPainter old) => old.color != color;
}

class _SettingsIcon extends StatelessWidget {
  final bool active;
  const _SettingsIcon({required this.active});
  @override
  Widget build(BuildContext context) {
    final c = active ? AppColors.blue : AppColors.mutedSoft;
    return CustomPaint(painter: _SettingsIconPainter(color: c), size: const Size(16, 16));
  }
}

class _SettingsIconPainter extends CustomPainter {
  final Color color;
  _SettingsIconPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(const Offset(8, 8), 2, p);
    for (final angle in [0.0, 90.0, 180.0, 270.0, 45.0, 135.0, 225.0, 315.0]) {
      final rad = angle * 3.14159 / 180;
      final dx = 8 + 5 * (angle % 90 == 0 ? (angle == 0 ? 1 : angle == 180 ? -1 : 0) : 0.0);
      final dy = 8 + 5 * (angle % 90 == 0 ? (angle == 90 ? 1 : angle == 270 ? -1 : 0) : 0.0);
      if (angle % 90 == 0) {
        final sx = 8 + 3 * (angle == 0 ? 1.0 : angle == 180 ? -1.0 : 0.0);
        final sy = 8 + 3 * (angle == 90 ? 1.0 : angle == 270 ? -1.0 : 0.0);
        canvas.drawLine(Offset(sx, sy), Offset(dx, dy), p);
      }
    }
  }
  @override
  bool shouldRepaint(_SettingsIconPainter old) => old.color != color;
}
