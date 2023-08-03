// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:abroadlink/config/colors.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignupView extends StatefulWidget {
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
      backgroundColor: mainBgColor,
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
                      "assets/images/png/two_boys_meeting.png",
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _userNameController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: boxBgColor,
                        filled: true,
                        isDense: true,
                        hintText: 'Username',
                        hintStyle:
                            GoogleFonts.poppins(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: boxBgColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: buttonColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: boxBgColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: buttonColor,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: _emailController,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: boxBgColor,
                        filled: true,
                        isDense: true,
                        hintText: 'Email',
                        hintStyle:
                            GoogleFonts.poppins(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: boxBgColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: buttonColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: boxBgColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: buttonColor,
                          ),
                        ),
                      ),
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
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: GoogleFonts.poppins(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: boxBgColor,
                        filled: true,
                        isDense: true,
                        hintText: 'Password',
                        hintStyle:
                            GoogleFonts.poppins(color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: boxBgColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: buttonColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: boxBgColor),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: buttonColor,
                          ),
                        ),
                      ),
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
                        final isAuthLoading = ref.watch(authProvider);
                        return isAuthLoading
                            ? Center(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: lightColor,
                                ),
                              )
                            : MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final authServiceProvider =
                                        ref.read(authProvider.notifier);

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
                                      Navigator.pushNamed(
                                        context,
                                        "/setupProfileView",
                                        arguments: {
                                          "username": _userNameController.text,
                                          "email": _emailController.text,
                                          "password": _passwordController.text
                                        },
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
                                color: buttonColor,
                                child: Text(
                                  'Register',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
