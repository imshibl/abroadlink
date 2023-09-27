// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/const/images.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:abroadlink/notifiers/location_notifier/location.notifier.dart';
import 'package:abroadlink/views/app/auth_views/signup.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgot_pswd.view.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginView());
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ref.read(locationNotifierProvider.notifier).getPermission();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Center(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'AbroadLink',
                        style: GoogleFonts.montserrat(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Text(
                        "Link with like minded people",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      SizedBox(height: 10.0),
                      Image.asset(
                        ConstImages.twoBoysFlyingImage,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      SizedBox(height: 20.0),
                      AuthTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!value.contains('@gmail.com')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.0),
                      AuthTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, ForgotPasswordView.route());
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Consumer(builder: (context, ref, _) {
                        final isAuthLoading = ref.watch(authNotifierProvider);
                        return SizedBox(
                          width: double.infinity,
                          child: isAuthLoading
                              ? CustomCircularProgressIndicatior1()
                              : MaterialButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      final authServiceProvider = ref
                                          .read(authNotifierProvider.notifier);
                                      await authServiceProvider
                                          .loginWithEmailAndPassword(
                                              _emailController.text,
                                              _passwordController.text,
                                              context);
                                    }
                                  },
                                  elevation: 0,
                                  color: ConstColors.buttonColor,
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ),
                        );
                      }),
                      Consumer(builder: (context, ref, _) {
                        final isAuthLoading = ref.watch(authNotifierProvider);
                        return isAuthLoading
                            ? SizedBox()
                            : LoginOrSignup(
                                questionText: "New user?",
                                navText: "Signup",
                                onTap: () {
                                  Navigator.push(context, SignupView.route());
                                },
                              );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCircularProgressIndicatior1 extends StatelessWidget {
  const CustomCircularProgressIndicatior1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        color: ConstColors.lightColor,
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    this.textInputAction,
    required this.validator,
    this.isPassword,
    required this.controller,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputAction? textInputAction;
  final String? Function(dynamic value) validator;
  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        textInputAction: textInputAction ?? TextInputAction.done,
        obscureText: isPassword ?? false,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          fillColor: ConstColors.boxBgColor,
          filled: true,
          isDense: true,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstColors.boxBgColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ConstColors.buttonColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ConstColors.boxBgColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ConstColors.buttonColor,
            ),
          ),
        ),
        validator: validator);
  }
}
