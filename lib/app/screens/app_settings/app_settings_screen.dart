import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/sync_state.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPad + 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _ProfileCard(),
                  ),
                  const SizedBox(height: 22),
                  _buildSecurityGroup(),
                  _buildSyncGroup(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityGroup() {
    final auth = Get.find<AuthController>();
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
                Obx(() => _SecurityToggleRow(
                      icon: _SecurityIconType.face,
                      label: 'Face ID',
                      value: auth.biometricEnabled.value,
                      onChanged: (v) async {
                        if (v) {
                          final ok = await auth.tryBiometric();
                          auth.biometricEnabled.value = ok;
                          if (!ok) {
                            Get.snackbar(
                              '',
                              'Face ID not available',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.ink,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                              duration: const Duration(seconds: 2),
                            );
                          }
                        } else {
                          auth.biometricEnabled.value = false;
                        }
                      },
                    )),
                const Divider(height: 1, color: AppColors.line, indent: 62, endIndent: 16),
                _SecurityRow(
                  icon: _SecurityIconType.key,
                  label: 'Change passcode',
                  value: null,
                  warn: false,
                  onTap: () => Get.toNamed(AppRoutes.onboarding),
                ),
                const Divider(height: 1, color: AppColors.line, indent: 62, endIndent: 16),
                _SecurityRow(
                  icon: _SecurityIconType.backup,
                  label: 'Recovery kit',
                  value: 'Not saved',
                  warn: true,
                  isLast: true,
                  onTap: () => Get.snackbar(
                    '',
                    'Recovery kit coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.ink,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 14,
                    duration: const Duration(seconds: 2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncGroup() {
    final app = Get.find<AppController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              'SYNC',
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
                Obx(() => _ICloudRow(
                      enabled: app.iCloudEnabled.value,
                      state: app.syncState.value,
                      lastSyncedAt: app.lastSyncedAt.value,
                      onChanged: (v) => app.toggleICloud(v),
                    )),
                const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
                _PlainRow(
                  label: 'Paired devices',
                  value: '2',
                  isLast: true,
                  onTap: () => Get.snackbar(
                    '',
                    'Device management coming soon',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.ink,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 14,
                    duration: const Duration(seconds: 2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    final app = Get.find<AppController>();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blueDeep, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'R',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Riley Ng',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'riley.ng@fastmail.com',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xD9FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Obx(() =>
                      _Stat(value: '${app.accounts.length}', label: 'Accounts')),
                  const SizedBox(width: 18),
                  const _Stat(value: 'iPhone', label: 'Device'),
                  const SizedBox(width: 18),
                  const _Stat(value: 'E2EE', label: 'Sync'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xBFFFFFFF),
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

enum _SecurityIconType { face, key, backup }

class _SecurityRow extends StatelessWidget {
  final _SecurityIconType icon;
  final String label;
  final String? value;
  final bool warn;
  final bool isLast;
  final VoidCallback? onTap;

  const _SecurityRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.warn,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: warn ? AppColors.orangeSoft : AppColors.blueSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: _buildIcon(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: TextStyle(
                  fontSize: 14,
                  color: warn ? AppColors.orange : AppColors.muted,
                  fontWeight: warn ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right, size: 16, color: AppColors.mutedSoft),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (icon) {
      case _SecurityIconType.face:
        return const Icon(Icons.face_outlined, size: 18, color: AppColors.blue);
      case _SecurityIconType.key:
        return const Icon(Icons.key_outlined, size: 18, color: AppColors.blue);
      case _SecurityIconType.backup:
        return const Icon(Icons.security_outlined, size: 18, color: AppColors.orange);
    }
  }
}

class _SecurityToggleRow extends StatelessWidget {
  final _SecurityIconType icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SecurityToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.blueSoft,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.face_outlined, size: 18, color: AppColors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: AppColors.ink),
            ),
          ),
          _Toggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ICloudRow extends StatelessWidget {
  final bool enabled;
  final SyncState state;
  final DateTime? lastSyncedAt;
  final ValueChanged<bool> onChanged;

  const _ICloudRow({
    required this.enabled,
    required this.state,
    required this.lastSyncedAt,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle;
    if (!enabled) {
      subtitle = 'Off · data stays on device';
    } else {
      switch (state) {
        case SyncState.syncing:
          subtitle = 'Syncing…';
          break;
        case SyncState.error:
          subtitle = 'Sync failed';
          break;
        case SyncState.synced:
          subtitle = lastSyncedAt == null
              ? 'Up to date'
              : 'Last synced ${_timeAgo(lastSyncedAt!)}';
          break;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'iCloud sync',
                  style: TextStyle(fontSize: 15, color: AppColors.ink),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (enabled && state == SyncState.syncing) ...[
                      const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.6,
                          color: AppColors.orange,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: state == SyncState.error
                              ? AppColors.orange
                              : AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _Toggle(value: enabled, onChanged: onChanged),
        ],
      ),
    );
  }
}

String _timeAgo(DateTime t) {
  final diff = DateTime.now().difference(t);
  if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} h ago';
  return '${diff.inDays} d ago';
}

class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

class _PlainRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final VoidCallback? onTap;

  const _PlainRow({
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
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppColors.muted),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.mutedSoft),
          ],
        ),
      ),
    );
  }
}
