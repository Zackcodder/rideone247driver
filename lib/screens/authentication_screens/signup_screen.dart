import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/provider/authprovider.dart';
import 'package:ride_on_driver/screens/authentication_screens/forget_password.dart';

import '../../core/constants/colors.dart';
import '../../core/extensions/build_context_extensions.dart';
import '../../core/extensions/widget_extensions.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/app_text_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/spacing.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
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
              //app logo
              const AppLogo(),
              SizedBox(
                width: 220.w,
                child: Text(
                  'Hey, to join our community, please provide these details.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              ),
              const VerticalSpacing(50),
              //first name text field
              AppTextField(
                controller: firstNameController,
                hintText: 'Please Enter Your First Names',
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              //last name
              AppTextField(
                controller: lastNameController,
                hintText: 'Please Enter Your Last Names',
                prefixIcon: const Icon(
                  Icons.person_2_outlined,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              //phone number
              AppTextField(
                keyboardType: TextInputType.number,
                controller: phoneNumberController,
                hintText: 'Please Enter Your Phone Number',
                prefixIcon: const Icon(
                  Icons.phone_iphone_rounded,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              //email
              AppTextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                hintText: 'Please Enter Your Email',
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(20),
              //password
              AppTextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                hintText: 'Please Enter Your Password',
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.grey,
                ),
                isPassword: true,
              ),
              const VerticalSpacing(20),
              //gender
              AppTextField(
                capitalization: TextCapitalization.characters,
                controller: genderController,
                hintText: 'Please Enter Your Gender',
                prefixIcon: const Icon(
                  Icons.male,
                  color: AppColors.grey,
                ),
              ),
              const VerticalSpacing(50),
              //signup button
              authProvider.signUpLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  : AppElevatedButton.large(
                      onPressed: () async {
                        if(mounted){
                          final firstName = firstNameController.text;
                          final lastName = lastNameController.text;
                          final phone = phoneNumberController.text;
                          final password = passwordController.text;
                          final email = emailController.text;
                          final gender = genderController.text;
                          const String role = 'driver';
                          authProvider.signUp(context, firstName, lastName, phone,
                              password, email, gender, role);

                          setState(() {
                            authProvider.signUpLoading;
                          });
                        }
                      },
                      text: 'Sign Up',
                    ),
              const VerticalSpacing(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: context.textTheme.bodySmall,
                  ),
                  AppTextButton(
                    onPressed: () {
                      context.pop();
                    },
                    text: 'Log In',
                  )
                ],
              ),
              AppTextButton(
                onPressed: () {
                  context.push(const ForgetPasswordScreen());
                },
                text: 'Forgot Password?',
              ),
            ],
          ),
        ),
      ),
    ).onTap(context.unfocus);
  }
}
