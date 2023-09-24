// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/const/images.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:abroadlink/views/app/auth_views/login.view.dart';
import 'package:abroadlink/views/app/profile_setup_views/setup_profile.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignupView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => SignupView());
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Signup',
                      style: GoogleFonts.montserrat(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      "Meet new companions",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    SizedBox(height: 10.0),
                    Image.asset(
                      ConstImages.twoBoysMeetingImage,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    SizedBox(height: 20.0),
                    AuthTextField(
                      hintText: 'Username',
                      controller: _userNameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    AuthTextField(
                      hintText: 'Email',
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@gmail.com')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    AuthTextField(
                      hintText: 'Password',
                      controller: _passwordController,
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
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: Consumer(builder: (context, ref, _) {
                        final isAuthLoading = ref.watch(authNotifierProvider);
                        return isAuthLoading
                            ? Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: ConstColors.lightColor,
                                ),
                              )
                            : MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final authServiceProvider =
                                        ref.read(authNotifierProvider.notifier);

                                    bool isUsernameAvailable =
                                        await authServiceProvider
                                            .checkIfUsernameExists(
                                                _userNameController.text);

                                    bool isEmailAvailable =
                                        await authServiceProvider
                                            .checkIfEmailExists(
                                                _emailController.text);

                                    if (isUsernameAvailable &&
                                        isEmailAvailable) {
                                      Navigator.push(
                                        context,
                                        SetupProfileView.route(
                                            email: _emailController.text,
                                            username: _userNameController.text,
                                            password: _passwordController.text),
                                      );
                                    } else if (!isUsernameAvailable) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Username already taken, try another one"),
                                        ),
                                      );
                                    } else if (!isEmailAvailable) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Email already used by another account"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                elevation: 0,
                                color: ConstColors.buttonColor,
                                child: Text(
                                  'Register',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              );
                      }),
                    ),
                    Consumer(builder: (context, ref, _) {
                      final isAuthLoading = ref.watch(authNotifierProvider);
                      return isAuthLoading
                          ? SizedBox()
                          : LoginOrSignup(
                              questionText: "Already have an account?",
                              navText: "Login",
                              onTap: () {
                                Navigator.pop(context);
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
    );
  }
}

class LoginOrSignup extends StatelessWidget {
  const LoginOrSignup({
    super.key,
    required this.questionText,
    required this.navText,
    required this.onTap,
  });

  final String questionText;
  final String navText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            navText,
            style: GoogleFonts.poppins(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
