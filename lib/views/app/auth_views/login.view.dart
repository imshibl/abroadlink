// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/config/colors.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:abroadlink/views/app/auth_views/signup.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginView());
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
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
                        "assets/images/png/two_boys_flying.png",
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      SizedBox(height: 20.0),
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
                            return 'Please enter an email';
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
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed("/forgotPasswordView");
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
                                  color: buttonColor,
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "New user?",
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, SignupView.route());
                            },
                            child: Text(
                              "Signup",
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
      ),
    );
  }
}
