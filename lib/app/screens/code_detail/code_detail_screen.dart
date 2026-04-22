import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/vault_controller.dart';
import '../../models/account.dart';
import '../../theme/app_theme.dart';
import '../../widgets/service_avatar.dart';

class CodeDetailScreen extends StatelessWidget {
  const CodeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Get.arguments as Account?;
    final name = account?.name ?? 'GitHub';
    final login = account?.login ?? 'riley.ng';
    final code = account?.code ?? '438210';
    final color = account?.color ?? const Color(0xFF0B1220);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SizedBox(height: topPad),
          _buildTopBar(),
          const SizedBox(height: 32),
          _buildIdentity(name: name, login: login, color: color),
          const SizedBox(height: 28),
          _buildCodeRing(code: code),
          const SizedBox(height: 24),
          _buildActions(code: code),
          const SizedBox(height: 20),
          _buildPrevCode(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            onTap: () => Get.back(),
            child: const Icon(Icons.chevron_left, size: 22, color: AppColors.ink),
          ),
          _NavButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(),
                const SizedBox(height: 3),
                _dot(),
                const SizedBox(height: 3),
                _dot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: AppColors.ink,
          shape: BoxShape.circle,
        ),
      );

  Widget _buildIdentity({
    required String name,
    required String login,
    required Color color,
  }) {
    return Column(
      children: [
        ServiceAvatar(
          letter: name[0],
          color: color,
          size: 72,
          borderRadius: 22,
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          login,
          style: const TextStyle(fontSize: 14, color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildCodeRing({required String code}) {
    final ctrl = Get.find<VaultController>();
    return Obx(() {
      final t = ctrl.t;
      final seconds = ctrl.secondsRemaining.value;
      final expiring = t < 0.2;
      final ringColor = expiring ? AppColors.orange : AppColors.blue;
      final codeA = code.substring(0, 3);
      final codeB = code.substring(3);

      return SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(260, 260),
              painter: _LargeRingPainter(t: t, color: ringColor),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'One-time code',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.muted,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      codeA,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      codeB,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: expiring ? AppColors.orange : AppColors.ink,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.muted,
                    ),
                    children: [
                      const TextSpan(text: 'refreshes in '),
                      TextSpan(
                        text: '${seconds}s',
                        style: const TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActions({required String code}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: code));
                Get.snackbar(
                  '',
                  'Code copied',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.ink,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 14,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copy, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Copy code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.qr_code_2, size: 24, color: AppColors.ink),
          ),
        ],
      ),
    );
  }

  Widget _buildPrevCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: const Row(
          children: [
            Text(
              'PREV',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '916 337',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 15,
                color: AppColors.mutedSoft,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _NavButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _LargeRingPainter extends CustomPainter {
  final double t;
  final Color color;

  _LargeRingPainter({required this.t, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const r = 118.0;

    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = AppColors.blueSoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r),
      -math.pi / 2,
      2 * math.pi * t,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_LargeRingPainter old) => old.t != t || old.color != color;
}
