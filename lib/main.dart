import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/controllers/app_controller.dart';
import 'app/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'app/widgets/app_lifecycle_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(AppController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(const KeyringApp());
}

class KeyringApp extends StatelessWidget {
  const KeyringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Keyring',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.routes,
      builder: (context, child) => AppLifecycleGate(child: child ?? const SizedBox()),
    );
  }
}
