import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus_test/features/auth/presentation/controllers/auth_controller.dart';
import 'package:novindus_test/screen/home_screen.dart';
import 'package:novindus_test/core/utils/app_theme.dart';
import 'package:novindus_test/core/widgets/primary_button.dart';
import 'package:novindus_test/core/widgets/custom_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().addListener(_authListener);
    });
  }

  void _authListener() {
    if (!mounted) return;
    final authController = context.read<AuthController>();

    if (authController.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }

    if (authController.errorMessage != null) {
      CustomSnackBar.showSnackBar(
        context,
        authController.errorMessage!,
        isError: true,
      );
      authController.resetError();
    }
  }

  @override
  void dispose() {
    try {
      context.read<AuthController>().removeListener(_authListener);
    } catch (_) {}
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'Enter Your\nMobile Number',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '+91',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Enter Mobile Number',
                      ),
                      style: const TextStyle(color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Consumer<AuthController>(
                  builder: (context, auth, _) {
                    return auth.isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Continue',
                            onPressed: () {
                              if (_phoneController.text.isNotEmpty) {
                                auth.login(_phoneController.text);
                              }
                            },
                          );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
