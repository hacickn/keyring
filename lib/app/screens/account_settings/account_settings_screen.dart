import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../models/account.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/service_avatar.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passed = Get.arguments as Account;
    final topPad = MediaQuery.of(context).padding.top;
    final app = Get.find<AppController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() {
        final current =
            app.accounts.firstWhereOrNull((a) => a.id == passed.id);
        if (current == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.until((r) => r.settings?.name == AppRoutes.vault);
          });
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            SizedBox(height: topPad),
            _buildHeader(current.name),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    _buildIdentity(account: current),
                    const SizedBox(height: 28),
                    _buildDetailsGroup(context, current, app),
                    const SizedBox(height: 20),
                    _buildSecurityGroup(current, app),
                    const SizedBox(height: 24),
                    _buildDangerGroup(context, current, app),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
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

  Widget _buildIdentity({required Account account}) {
    return Column(
      children: [
        ServiceAvatar(
          letter: account.name[0],
          color: account.color,
          size: 68,
          borderRadius: 20,
        ),
        const SizedBox(height: 14),
        Text(
          account.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Added ${_formatDate(account.addedDate)}',
          style: const TextStyle(fontSize: 13, color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildDetailsGroup(
      BuildContext context, Account account, AppController app) {
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
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                _SettingsRow(
                  label: 'Issuer',
                  value: account.name,
                  onTap: () => _editField(
                    context,
                    title: 'Issuer',
                    initial: account.name,
                    onSave: (v) =>
                        app.updateAccount(account.copyWith(name: v)),
                  ),
                ),
                const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
                _SettingsRow(
                  label: 'Account',
                  value: account.login,
                  onTap: () => _editField(
                    context,
                    title: 'Account',
                    initial: account.login,
                    onSave: (v) =>
                        app.updateAccount(account.copyWith(login: v)),
                  ),
                ),
                const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
                const _SettingsRow(
                  label: 'Algorithm',
                  value: 'SHA-1 · 6 digits',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityGroup(Account account, AppController app) {
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
                _ToggleRow(
                  label: 'Require Face ID to reveal',
                  value: account.requireBiometric,
                  onChanged: (v) => app
                      .updateAccount(account.copyWith(requireBiometric: v)),
                ),
                const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
                _ToggleRow(
                  label: 'Hide code by default',
                  value: account.hideByDefault,
                  onChanged: (v) =>
                      app.updateAccount(account.copyWith(hideByDefault: v)),
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerGroup(
      BuildContext context, Account account, AppController app) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Remove account?'),
              content: Text(
                  'This will permanently remove ${account.name} from your vault.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    app.removeAccount(account.id);
                    Get.until((r) => r.settings?.name == AppRoutes.vault);
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

  Future<void> _editField(
    BuildContext context, {
    required String title,
    required String initial,
    required ValueChanged<String> onSave,
  }) async {
    final controller = TextEditingController(text: initial);
    await Get.dialog(
      AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final v = controller.text.trim();
              if (v.isNotEmpty) onSave(v);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
              ),
            ),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15, color: AppColors.muted),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: onTap == null ? AppColors.line : AppColors.mutedSoft,
            ),
          ],
        ),
      ),
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
