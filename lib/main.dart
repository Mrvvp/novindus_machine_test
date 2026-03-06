import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus_test/screen/login_screen.dart';
import 'package:novindus_test/core/utils/app_theme.dart';
import 'package:novindus_test/core/di/dependency_injection.dart';
import 'package:novindus_test/features/auth/presentation/controllers/auth_controller.dart';
import 'package:novindus_test/features/home/presentation/controllers/home_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthController(loginUseCase: DependencyInjection.loginUseCase),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeController(
            getHomeDataUseCase: DependencyInjection.getHomeDataUseCase,
            getCategoriesUseCase: DependencyInjection.getCategoriesUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novindus Test',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
