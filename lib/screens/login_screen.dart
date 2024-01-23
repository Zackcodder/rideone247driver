import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/screens/forget_password.dart';
import 'package:ride_on_driver/screens/signup_screen.dart';
import 'package:ride_on_driver/widgets/app_elevated_button.dart';
import 'package:ride_on_driver/widgets/app_logo.dart';
import 'package:ride_on_driver/widgets/app_text_field.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../core/constants/colors.dart';
import '../core/extensions/build_context_extensions.dart';
import '../core/extensions/widget_extensions.dart';
import '../widgets/app_text_button.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const VerticalSpacing(50),
              //app logo
              const AppLogo(),
              //welcome note
              SizedBox(
                width: 220.w,
                child: Text(
                  'Welcome back. Please provide your access codes to gain access into our community.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const VerticalSpacing(100),
              //email text field
              AppTextField(
                hintText: 'Cristianoronaldo@gmail.com',
                prefixIcon: const Icon(
                  Icons.alternate_email_rounded,
                  color: AppColors.grey,
                ),
                controller: emailController,
              ),
              const VerticalSpacing(20),
              //password text field
              AppTextField(
                hintText: 'Your Password',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.grey,
                ),
                isPassword: true,
                controller: passwordController,
              ),
              const VerticalSpacing(50),
              ///login button
              authProvider.signInLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  :
              AppElevatedButton.large(
                      onPressed: () async {
                        final email = emailController.text;
                        final password = passwordController.text;
                        authProvider.signIn(context, email, password);
                      },
                      text: 'Login',
                    ),
              const VerticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: context.textTheme.bodySmall,
                  ),
                  AppTextButton(
                    onPressed: () => context.push(const SignupScreen()),
                    text: 'Sign Up',
                  )
                ],
              ),
              AppTextButton(
                onPressed: () {
                  context.push(const ForgetPasswordScreen());
                },
                text: 'Forgot Password?',
              ),
              const VerticalSpacing(100),
            ],
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
