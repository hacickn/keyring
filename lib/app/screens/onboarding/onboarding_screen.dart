import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/passcode_keypad.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

enum _Step { create, confirm, biometric }

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _keypadKey = GlobalKey<PasscodeKeypadState>();
  _Step _step = _Step.create;
  String _firstCode = '';
  bool _error = false;

  void _onComplete(String code) {
    switch (_step) {
      case _Step.create:
        setState(() {
          _firstCode = code;
          _step = _Step.confirm;
          _error = false;
        });
        _keypadKey.currentState?.clear();
        break;
      case _Step.confirm:
        if (code == _firstCode) {
          Get.find<AuthController>().setPasscode(code);
          setState(() {
            _step = _Step.biometric;
            _error = false;
          });
        } else {
          setState(() => _error = true);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _firstCode = '';
                _step = _Step.create;
                _error = false;
              });
            }
          });
        }
        break;
      case _Step.biometric:
        break;
    }
  }

  void _finish() {
    final auth = Get.find<AuthController>();
    auth.unlock();
    Get.offAllNamed(AppRoutes.vault);
  }

  Future<void> _enableBiometric() async {
    final auth = Get.find<AuthController>();
    final ok = await auth.tryBiometric();
    if (ok) auth.biometricEnabled.value = true;
    _finish();
  }

  @override
  Widget build(BuildContext context) {
    if (_step == _Step.biometric) {
      return _buildBiometricStep();
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Text(
              _step == _Step.create ? 'Create a passcode' : 'Confirm passcode',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Choose a 6-digit passcode to protect your vault.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.45),
              ),
            ),
            const Spacer(),
            PasscodeKeypad(
              key: _keypadKey,
              onComplete: _onComplete,
              error: _error,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricStep() {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.blueSoft,
                  borderRadius: BorderRadius.circular(22),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.face_retouching_natural,
                  size: 40,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enable Face ID?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unlock Keyring instantly with Face ID instead of your passcode.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.45),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _enableBiometric,
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
                    'Enable Face ID',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _finish,
                child: Container(
                  height: 54,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'Not now',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
