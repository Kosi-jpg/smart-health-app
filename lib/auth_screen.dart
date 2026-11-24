import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final supabase = Supabase.instance.client;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color green = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFEAF3EA);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void openDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          loginScreenBuilder: () => const AuthScreen(),
        ),
      ),
    );
  }

  Future<void> authenticate() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please enter your email and password.');
      return;
    }

    if (!isLogin) {
      if (nameController.text.trim().isEmpty) {
        showMessage('Please enter your full name.');
        return;
      }

      if (password != confirmPasswordController.text) {
        showMessage('Passwords do not match.');
        return;
      }
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters.');
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (!mounted) return;

        // Tell the device password manager login succeeded.
        TextInput.finishAutofillContext(shouldSave: true);

        openDashboard();
      } else {
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'full_name': nameController.text.trim(),
          },
        );

        if (!mounted) return;

        // Tell the device password manager signup succeeded.
        TextInput.finishAutofillContext(shouldSave: true);

        if (response.session != null) {
          openDashboard();
        } else {
          showMessage(
            'Account created! Check your email to confirm your account.',
          );
        }
      }
    } on AuthException catch (error) {
      if (mounted) showMessage(error.message);
    } catch (error) {
      if (mounted) showMessage('Error: $error');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    List<String>? autofillHints,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: green),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF7F9F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE1E9E1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE1E9E1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: green,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F4),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 440,
              ),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(23),
                border: Border.all(
                  color: const Color(0xFFE8EEE8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: lightGreen,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.health_and_safety_outlined,
                          color: green,
                          size: 43,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Smart Health',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      isLogin
                          ? 'Welcome back! Sign in to continue.'
                          : 'Create an account and begin your wellness journey.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      isLogin
                          ? 'Login to your account'
                          : 'Create your account',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Full name
                    if (!isLogin) ...[
                      buildInputField(
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        controller: nameController,
                        autofillHints: const [
                          AutofillHints.name,
                        ],
                      ),
                      const SizedBox(height: 17),
                    ],

                    // Email
                    buildInputField(
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.username,
                        AutofillHints.email,
                      ],
                    ),

                    const SizedBox(height: 17),

                    // Password
                    buildInputField(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      controller: passwordController,
                      obscureText: obscurePassword,
                      autofillHints: [
                        isLogin
                            ? AutofillHints.password
                            : AutofillHints.newPassword,
                      ],
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),

                    // Confirm password
                    if (!isLogin) ...[
                      const SizedBox(height: 17),
                      buildInputField(
                        label: 'Confirm Password',
                        icon: Icons.lock_reset_outlined,
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        autofillHints: const [
                          AutofillHints.newPassword,
                        ],
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ],

                    const SizedBox(height: 25),

                    // Main button
                    SizedBox(
                      height: 53,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : authenticate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isLogin ? 'Login' : 'Create Account',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Switch login/signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            isLogin
                                ? "Don't have an account?"
                                : 'Already have an account?',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    isLogin = !isLogin;
                                  });
                                },
                          child: Text(
                            isLogin ? 'Sign Up' : 'Login',
                            style: const TextStyle(
                              color: green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Center(
                      child: Text(
                        'Your health matters.',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
