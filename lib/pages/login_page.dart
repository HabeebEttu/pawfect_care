import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/pages/forgot_password_page.dart';
import 'package:pawfect_care/role_wrapper.dart';
import 'package:pawfect_care/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:pawfect_care/routes/app_routes.dart';
import 'package:pawfect_care/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _rememberMe = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: PawfectCareTheme.backgroundWhite,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 48 : 24,
                      ),
                      child: Column(
                        children: [
                          // Header Section
                          Expanded(
                            flex: isTablet ? 2 : 1,
                            child: _buildHeaderSection(screenHeight, isTablet),
                          ),

                          // Form Section
                          Expanded(
                            flex: 3,
                            child: _buildFormSection(authProvider, isTablet),
                          ),

                          // Footer Section
                          _buildFooterSection(),
                          SizedBox(height: keyboardHeight > 0 ? 20 : 40),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(double screenHeight, bool isTablet) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PawfectCareTheme.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pets,
                size: isTablet ? 80 : 60,
                color: PawfectCareTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome Back!',
              style: isTablet
                  ? PawfectCareTheme.headingLarge.copyWith(
                      color: PawfectCareTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    )
                  : PawfectCareTheme.headingMedium.copyWith(
                      color: PawfectCareTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to continue your pet care journey',
              style: PawfectCareTheme.bodyLarge.copyWith(
                color: PawfectCareTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection(AuthProvider authProvider, bool isTablet) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildEmailField(),
            const SizedBox(height: 20),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildRememberMeAndForgotPassword(),
            const SizedBox(height: 32),
            _buildLoginButton(authProvider),
            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),
            _buildSocialLoginButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: PawfectCareTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: PawfectCareTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: PawfectCareTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            hintStyle: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textMuted,
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: PawfectCareTheme.textMuted,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: PawfectCareTheme.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            } else if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: PawfectCareTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: PawfectCareTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _isObscure,
          style: PawfectCareTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textMuted,
            ),
            prefixIcon: Icon(
              Icons.lock_outlined,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: PawfectCareTheme.primaryBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
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
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: PawfectCareTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                });
              },
              child: Text(
                'Remember me',
                style: PawfectCareTheme.bodyMedium.copyWith(
                  color: PawfectCareTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const ForgotPasswordPage();
            },));
          },
          child: Text(
            'Forgot Password?',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(AuthProvider authProvider) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
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
                      MaterialPageRoute(builder: (_) => const RoleWrapper()),
                    );

                  } else if (mounted && authProvider.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(authProvider.errorMessage!),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: PawfectCareTheme.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Sign In',
                style: PawfectCareTheme.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textSecondary,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle Google sign in
            },
            icon: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.g_mobiledata,
                color: Colors.white,
                size: 16,
              ),
            ),
            label: Text(
              'Continue with Google',
              style: PawfectCareTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // Handle Apple sign in
            },
            icon: const Icon(Icons.apple, color: Colors.black, size: 20),
            label: Text(
              'Continue with Apple',
              style: PawfectCareTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account? ',
            style: PawfectCareTheme.bodyMedium.copyWith(
              color: PawfectCareTheme.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.register);
            },
            child: Text(
              'Sign Up',
              style: PawfectCareTheme.bodyMedium.copyWith(
                color: PawfectCareTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
