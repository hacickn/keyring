import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/passcode_keypad.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _keypadKey = GlobalKey<PasscodeKeypadState>();
  bool _error = false;
  bool _biometricAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometricAuto());
  }

  Future<void> _tryBiometricAuto() async {
    if (_biometricAttempted) return;
    _biometricAttempted = true;
    final auth = Get.find<AuthController>();
    if (!auth.biometricEnabled.value) return;
    final ok = await auth.tryBiometric();
    if (ok) _unlock();
  }

  void _unlock() {
    Get.find<AuthController>().unlock();
    Get.offAllNamed(AppRoutes.vault);
  }

  void _onComplete(String code) {
    final auth = Get.find<AuthController>();
    if (auth.verify(code)) {
      _unlock();
    } else {
      setState(() => _error = true);
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) {
          _keypadKey.currentState?.shakeAndClear();
          setState(() => _error = false);
        }
      });
    }
  }

  Future<void> _manualBiometric() async {
    final auth = Get.find<AuthController>();
    final ok = await auth.tryBiometric();
    if (ok) _unlock();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 28),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blueDeep, AppColors.blue],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.lock_outline, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Keyring is locked',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _error ? 'Incorrect passcode' : 'Enter your passcode',
                style: TextStyle(
                  fontSize: 14,
                  color: _error ? AppColors.orange : AppColors.muted,
                ),
              ),
              const Spacer(),
              Obx(() => PasscodeKeypad(
                    key: _keypadKey,
                    onComplete: _onComplete,
                    error: _error,
                    showBiometric: auth.biometricEnabled.value,
                    onBiometric: _manualBiometric,
                  )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
