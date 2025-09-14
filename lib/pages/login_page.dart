import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart'; 
import 'package:pawfect_care/pages/pet_owner_dashboard.dart';
import 'package:pawfect_care/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PawfectCareTheme.backgroundWhite,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            // Wrap the main content with a Consumer to listen to AuthProvider changes
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      'Welcome to Pawfect Care',
                      style: PawfectCareTheme.headingLarge.copyWith(
                        color: PawfectCareTheme.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to your account to continue',
                      style: PawfectCareTheme.bodyMedium.copyWith(
                        color: PawfectCareTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Email Address',
                      style: PawfectCareTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: PawfectCareTheme.bodyMedium,
                      decoration: InputDecoration(
  hintText: 'Enter your account email address',
  hintStyle: PawfectCareTheme.bodyMedium.copyWith(
    color: PawfectCareTheme.textMuted,
  ),
  
).copyWith(
  enabledBorder: PawfectCareTheme.inputDecorationTheme.enabledBorder,
  focusedBorder: PawfectCareTheme.inputDecorationTheme.focusedBorder,
),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Password',
                      style: PawfectCareTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      style: PawfectCareTheme.bodyMedium,
                      decoration: InputDecoration(
  hintText: 'Enter your account password',
  hintStyle: PawfectCareTheme.bodyMedium.copyWith(
    color: PawfectCareTheme.textMuted,
  ),
  suffixIcon: IconButton(
    icon: Icon(
      _isObscure ? Icons.visibility_off : Icons.visibility,
      color: PawfectCareTheme.textMuted,
    ),
    onPressed: () {
      setState(() {
        _isObscure = !_isObscure;
      });
    },
  ),
).copyWith(
  // apply theme overrides from your PawfectCareTheme
  enabledBorder: PawfectCareTheme.inputDecorationTheme.enabledBorder,
  focusedBorder: PawfectCareTheme.inputDecorationTheme.focusedBorder,
),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: PawfectCareTheme.linkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await authProvider.signIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                                if (mounted && authProvider.user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HomePage(),
                                    ),
                                  );
                                } else if (mounted &&
                                    authProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authProvider.errorMessage!),
                                    ),
                                  );
                                }
                              }
                            },
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Log In'),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: PawfectCareTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Sign Up',
                            style: PawfectCareTheme.linkText,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
