import 'package:bunk_mate/screens/auth/signup_screen.dart';
import 'package:bunk_mate/screens/easter_eggs.dart';
import 'package:bunk_mate/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bunk_mate/controllers/auth/login_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  LoginController loginController = Get.put(LoginController());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color bgColor = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);
  final Color accentColor = const Color(0xFF4CAF50);
  final Color textColor = Colors.white;
  final Color secondaryTextColor = Colors.white70;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.08),
                  _buildLogo(),
                  SizedBox(height: screenSize.height * 0.04),
                  Text(
                    "Welcome back",
                    style: GoogleFonts.lexend(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in to your account",
                    style: GoogleFonts.lexend(
                      color: secondaryTextColor,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildAuthField(
                          controller: loginController.usernameController,
                          icon: Icons.person_outline,
                          hintText: "Username",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Username is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildAuthField(
                          controller: loginController.passwordController,
                          icon: Icons.lock_outline,
                          hintText: "Password",
                          isObscure: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(const MyWidget());
                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.lexend(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  _buildLoginButton(),
                  SizedBox(height: screenSize.height * 0.04),
                  _buildSignUpRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: accentColor,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.school,
          color: Colors.black,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildAuthField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isObscure = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        style: GoogleFonts.lexend(color: textColor),
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.lexend(color: secondaryTextColor),
          prefixIcon: Icon(icon, color: accentColor),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          bool success = await loginController.loginFunction();
          if (success) {
            Get.off(Navigation());
          } else {
            _showErrorSnackbar("Login failed. Please try again.");
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 5,
      ),
      child: Center(
        child: Text(
          "Log In",
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.lexend(
            color: secondaryTextColor,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.off(const SignupScreen());
          },
          child: Text(
            "Sign up",
            style: GoogleFonts.lexend(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
}
