import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _ProfileCard(),
                  ),
                  const SizedBox(height: 22),
                  _buildSecurityGroup(),
                  const SizedBox(height: 0),
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
                _SecurityRow(
                  icon: _SecurityIconType.face,
                  label: 'App lock',
                  value: 'Face ID',
                  warn: false,
                ),
                const Divider(height: 1, color: AppColors.line, indent: 62, endIndent: 16),
                _SecurityRow(
                  icon: _SecurityIconType.key,
                  label: 'Change passphrase',
                  value: null,
                  warn: false,
                ),
                const Divider(height: 1, color: AppColors.line, indent: 62, endIndent: 16),
                _SecurityRow(
                  icon: _SecurityIconType.backup,
                  label: 'Recovery kit',
                  value: 'Not saved',
                  warn: true,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncGroup() {
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
                _PlainRow(label: 'iCloud sync', value: 'On · encrypted'),
                const Divider(height: 1, color: AppColors.line, indent: 16, endIndent: 16),
                _PlainRow(label: 'Paired devices', value: '2', isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          // Orange accent circle
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
                  _Stat(value: '7', label: 'Accounts'),
                  const SizedBox(width: 18),
                  _Stat(value: 'iPhone', label: 'Device'),
                  const SizedBox(width: 18),
                  _Stat(value: 'E2EE', label: 'Sync'),
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

  const _SecurityRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.warn,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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

class _PlainRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _PlainRow({
    required this.label,
    required this.value,
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
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppColors.muted),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.mutedSoft),
        ],
      ),
    );
  }
}
