import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/add_account_controller.dart';
import '../../theme/app_theme.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Stack(
        children: [
          // Camera scene background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.2),
                  radius: 1.2,
                  colors: [Color(0xFF1a2a44), Color(0xFF0a0f1c), Color(0xFF000000)],
                  stops: [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Scanline overlay
          Positioned.fill(
            child: CustomPaint(painter: _ScanlinePainter()),
          ),
          // Content
          Column(
            children: [
              SizedBox(height: topPad),
              _buildHeader(),
              Expanded(child: _buildScannerArea()),
              _buildBottomSheet(bottomPad: bottomPad),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _GlassButton(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, size: 16, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Add account',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          _GlassButton(
            child: const Icon(Icons.tune, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            children: [
              // Corner brackets (orange)
              _Corner(alignment: Alignment.topLeft,
                  borderSide: _CornerSide.topLeft),
              _Corner(alignment: Alignment.topRight,
                  borderSide: _CornerSide.topRight),
              _Corner(alignment: Alignment.bottomLeft,
                  borderSide: _CornerSide.bottomLeft),
              _Corner(alignment: Alignment.bottomRight,
                  borderSide: _CornerSide.bottomRight),
              // Scanning beam
              Positioned(
                top: 260 * 0.4,
                left: 8,
                right: 8,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.orange,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // Faint QR dot grid
              Positioned(
                top: 40,
                left: 40,
                right: 40,
                bottom: 40,
                child: Opacity(
                  opacity: 0.5,
                  child: CustomPaint(painter: _DotGridPainter()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Point at the QR code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 44),
          child: Text(
            "From the site's 2FA setup page. We'll detect it automatically.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xA6FFFFFF),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet({required double bottomPad}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(18, 18, 18, bottomPad + 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Builder(
        builder: (context) => Row(
          children: [
            Expanded(
              child: _BottomAction(
                label: 'Enter setup key',
                icon: Icons.mail_outline,
                onTap: () => _showSetupKeySheet(context),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _BottomAction(
                label: 'Scan image',
                icon: Icons.camera_alt_outlined,
                primary: true,
                onTap: () => Get.snackbar(
                  '',
                  'QR scanning coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.ink,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 14,
                  duration: const Duration(seconds: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetupKeySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _SetupKeySheet(),
    );
  }
}

class _SetupKeySheet extends StatelessWidget {
  const _SetupKeySheet();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AddAccountController>();
    final insets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: insets),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Enter setup key',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Enter the account details and the base32 secret from your site\'s 2FA setup.',
              style: TextStyle(fontSize: 13, color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 18),
            Obx(() => _LabeledField(
                  label: 'Account name',
                  controller: ctrl.nameCtrl,
                  hint: 'e.g. r.ng@example.com',
                  error: ctrl.nameError.value,
                )),
            const SizedBox(height: 14),
            _LabeledField(
              label: 'Issuer (optional)',
              controller: ctrl.issuerCtrl,
              hint: 'e.g. GitHub',
            ),
            const SizedBox(height: 14),
            Obx(() => _LabeledField(
                  label: 'Secret key',
                  controller: ctrl.secretCtrl,
                  hint: 'JBSWY3DPEHPK3PXP',
                  monospace: true,
                  error: ctrl.secretError.value,
                )),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                if (ctrl.submit()) {
                  Get.back();
                  Get.back();
                  Get.snackbar(
                    '',
                    'Account added',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.ink,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 14,
                    duration: const Duration(seconds: 2),
                  );
                }
              },
              child: Container(
                height: 54,
                width: double.infinity,
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
                alignment: Alignment.center,
                child: const Text(
                  'Save account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? error;
  final bool monospace;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.error,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = error != null ? AppColors.orange : AppColors.line;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: error != null ? 1.5 : 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: TextField(
            controller: controller,
            autocorrect: false,
            style: TextStyle(
              fontFamily: monospace ? 'monospace' : null,
              fontSize: 15,
              color: AppColors.ink,
              letterSpacing: monospace ? 1.2 : 0,
            ),
            cursorColor: AppColors.blue,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.mutedSoft),
              isDense: true,
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              error!,
              style: const TextStyle(fontSize: 12, color: AppColors.orange),
            ),
          ),
      ],
    );
  }
}

enum _CornerSide { topLeft, topRight, bottomLeft, bottomRight }

class _Corner extends StatelessWidget {
  final Alignment alignment;
  final _CornerSide borderSide;

  const _Corner({required this.alignment, required this.borderSide});

  @override
  Widget build(BuildContext context) {
    const size = 44.0;
    const thickness = 4.0;
    const radius = 20.0;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CornerPainter(
            side: borderSide,
            color: AppColors.orange,
            thickness: thickness,
            radius: radius,
          ),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final _CornerSide side;
  final Color color;
  final double thickness;
  final double radius;

  _CornerPainter({
    required this.side,
    required this.color,
    required this.thickness,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.square;

    final w = size.width;
    final h = size.height;

    final path = Path();
    switch (side) {
      case _CornerSide.topLeft:
        path.moveTo(0, h);
        path.lineTo(0, radius);
        path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
        path.lineTo(w, 0);
        break;
      case _CornerSide.topRight:
        path.moveTo(0, 0);
        path.lineTo(w - radius, 0);
        path.arcToPoint(Offset(w, radius), radius: Radius.circular(radius));
        path.lineTo(w, h);
        break;
      case _CornerSide.bottomLeft:
        path.moveTo(0, 0);
        path.lineTo(0, h - radius);
        path.arcToPoint(Offset(radius, h), radius: Radius.circular(radius));
        path.lineTo(w, h);
        break;
      case _CornerSide.bottomRight:
        path.moveTo(0, h);
        path.lineTo(w - radius, h);
        path.arcToPoint(Offset(w, h - radius), radius: Radius.circular(radius));
        path.lineTo(w, 0);
        break;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _GlassButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback onTap;

  const _BottomAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: primary ? AppColors.orange : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          boxShadow: primary
              ? [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..style = PaintingStyle.fill;

    for (double y = 0; y < size.height; y += 6) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 2), paint);
    }
  }

  @override
  bool shouldRepaint(_ScanlinePainter old) => false;
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;

    const spacing = 12.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => false;
}
