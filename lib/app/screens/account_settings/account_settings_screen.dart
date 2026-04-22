import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/account.dart';
import '../../theme/app_theme.dart';
import '../../widgets/service_avatar.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final requireFaceId = true.obs;
  final hideByDefault = false.obs;

  @override
  Widget build(BuildContext context) {
    final account = Get.arguments as Account?;
    final name = account?.name ?? 'AWS Root';
    final login = account?.login ?? 'r.ng+aws';
    final color = account?.color ?? const Color(0xFF232F3E);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          SizedBox(height: topPad),
          _buildHeader(name),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  _buildIdentity(name: name, login: login, color: color),
                  const SizedBox(height: 28),
                  _buildDetailsGroup(),
                  const SizedBox(height: 20),
                  _buildSecurityGroup(
                      requireFaceId: requireFaceId, hideByDefault: hideByDefault),
                  const SizedBox(height: 24),
                  _buildDangerGroup(name: name),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.chevron_left, size: 22, color: AppColors.ink),
              ),
            ),
          ),
          const Text(
            'Edit account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentity({
    required String name,
    required String login,
    required Color color,
  }) {
    return Column(
      children: [
        ServiceAvatar(letter: name[0], color: color, size: 68, borderRadius: 20),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Added Mar 12, 2026',
          style: TextStyle(fontSize: 13, color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildDetailsGroup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              'DETAILS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
                letterSpacing: 0.6,
              ),
            ),
          ),
          _SettingsCard(
            rows: [
              _SettingsRow(label: 'Issuer', value: 'AWS'),
              _SettingsRow(label: 'Account', value: 'r.ng+aws'),
              _SettingsRow(label: 'Algorithm', value: 'SHA-1 · 6 digits', isLast: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityGroup({
    required RxBool requireFaceId,
    required RxBool hideByDefault,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              'SECURITY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                Obx(() => _ToggleRow(
                      label: 'Require Face ID to reveal',
                      value: requireFaceId.value,
                      onChanged: (v) => requireFaceId.value = v,
                    )),
                const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
                Obx(() => _ToggleRow(
                      label: 'Hide code by default',
                      value: hideByDefault.value,
                      onChanged: (v) => hideByDefault.value = v,
                      isLast: true,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerGroup({required String name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Remove account?'),
              content: Text(
                  'This will permanently remove $name from your vault.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: AppColors.orange),
                  ),
                ),
              ],
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CustomPaint(painter: _WarningPainter()),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Remove from vault',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> rows;

  const _SettingsCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(children: rows),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _SettingsRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 15, color: AppColors.ink),
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 15, color: AppColors.muted),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.mutedSoft),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: AppColors.ink),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: value ? AppColors.blue : const Color(0xFFE4E4EA),
                borderRadius: BorderRadius.circular(99),
              ),
              padding: const EdgeInsets.all(2),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width / 2, 1)
      ..lineTo(size.width - 1, size.height - 1)
      ..lineTo(1, size.height - 1)
      ..close();
    canvas.drawPath(path, fillPaint);

    // Exclamation
    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.35),
      Offset(size.width / 2, size.height * 0.65),
      strokePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.78),
      1,
      strokePaint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_WarningPainter old) => false;
}
