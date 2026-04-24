import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import 'blur_overlay.dart';

class AppLifecycleGate extends StatefulWidget {
  final Widget child;
  const AppLifecycleGate({super.key, required this.child});

  @override
  State<AppLifecycleGate> createState() => _AppLifecycleGateState();
}

class _AppLifecycleGateState extends State<AppLifecycleGate>
    with WidgetsBindingObserver {
  bool _showBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : null;
    switch (state) {
      case AppLifecycleState.inactive:
        setState(() => _showBlur = true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        if (auth != null && auth.hasOnboarded.value) {
          auth.lock();
        }
        setState(() => _showBlur = true);
        break;
      case AppLifecycleState.resumed:
        setState(() => _showBlur = false);
        if (auth != null &&
            auth.hasOnboarded.value &&
            auth.isLocked.value &&
            Get.currentRoute != AppRoutes.lock) {
          Get.offAllNamed(AppRoutes.lock);
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showBlur) const BlurOverlay(),
      ],
    );
  }
}
