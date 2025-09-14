import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawfect_care/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:pawfect_care/models/role.dart';
import 'package:pawfect_care/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  Role? _selectedRole;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image(image: AssetImage('images/pawfectcare_logo.png'
                      ), height: 80,),
                  SizedBox(height: 6,),
                  Text(
                    'Sign Up',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            validator: (v) => v!.trim().isEmpty ? 'Name required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) =>
                            !EmailValidator.validate(v ?? '') ? 'Invalid email' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            obscureText: _obscure,
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) =>
                            (v?.length ?? 0) < 6 ? 'Min 6 characters' : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<Role>(
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedRole,
                            items: Role.values
                                .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.name),
                            ))
                                .toList(),
                            onChanged: (role) => setState(() => _selectedRole = role),
                            validator: (v) => v == null ? 'Select role' : null,
                          ),

                          const SizedBox(height: 20),

                          if (auth.errorMessage != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                auth.errorMessage!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 340,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  inherit: true,
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: auth.isLoading ? null : _register,
                              child: auth.isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Text('Create Account'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF0F9F4),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          'Login here',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Privacy / Terms line
                  Text(
                    'By creating an account, you agree to our Privacy Policy and Terms of Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    await auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text.trim(),
      role: _selectedRole!,
    );

    if (!mounted) return;

    if (auth.errorMessage != null) return;

    final uid = auth.user!.uid;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!mounted) return;

    final roleString = snap.data()?['role'] as String? ?? '';

    switch (roleString) {
      case 'user':
        Navigator.pushReplacementNamed(context, '/ownerDashboard');
        break;
      case 'vet':
        Navigator.pushReplacementNamed(context, '/vetDashboard');
        break;
      case 'shelter':
        Navigator.pushReplacementNamed(context, '/shelterDashboard');
        break;
      case 'admin':
        Navigator.pushReplacementNamed(context, '/adminDashboard');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/defaultDashboard');
    }
  }
}
