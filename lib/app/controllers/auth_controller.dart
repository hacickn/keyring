import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthController extends GetxController {
  final passcode = RxnString();
  final biometricEnabled = false.obs;
  final isLocked = true.obs;
  final hasOnboarded = false.obs;

  final LocalAuthentication _auth = LocalAuthentication();

  bool verify(String input) => input == passcode.value;

  void setPasscode(String code) {
    passcode.value = code;
    hasOnboarded.value = true;
  }

  void unlock() => isLocked.value = false;
  void lock() => isLocked.value = true;

  Future<bool> tryBiometric() async {
    try {
      final available = await _auth.canCheckBiometrics;
      if (!available) return false;
      return await _auth.authenticate(
        localizedReason: 'Unlock Keyring',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
