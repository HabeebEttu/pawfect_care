import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                vertical:40,
                ),
                child: Text('Login',style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.teal[700],
                    fontWeight: FontWeight.w900,
                ),),
              ),
              _buildFormField(context,"Email","Enter your email address", (
                value,
              ) {
                String email = _emailController.text;
                if (email.isEmpty) {
                  return "Please enter your email";
                } else if (!EmailValidator.validate(email)) {
                  return "Please enter a valid email";
                } else {
                  return null;
                }
              },
              false,
              _emailController,
              ),
              SizedBox(
                height: 20,
              ),
              _buildFormField(context,"Password","Enter your account password", (
                value,
              ) {
                String password = _passwordController.text;
                if (password.isEmpty) {
                  return "Please enter your password";
                } else if (password.length < 6) {
                  return "Password length is too short";
                } else {
                  return null;
                }
              },
              true,
              _passwordController,
              ),
              SizedBox(
                height: 5,
              ),
              _buildForgotPassword(context),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700, 
                  minimumSize: Size(double.infinity, 50),
                   elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
                  ),
                onPressed: () {},
                child: Text('Log In',style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                )),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont have an account? '),
                  GestureDetector(
                    onTap:(){
                      
                    },
                    child: Text('SignUp here',style: TextStyle(
                      decoration: TextDecoration.underline
                    ),),
                  )
                ]

              )

            ],
          ),
        ),
      ),
    );
  }

  Row _buildForgotPassword(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text('Forgot Password?',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: Colors.black87),
                  ),
                )
              ],);
  }



  Column _buildFormField(
    BuildContext context,
    String label,
    String placeholder,
    FormFieldValidator<String>? validator,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:"),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _isObscure : false, // 👈 only obscure if password field
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: const Color.fromARGB(255, 124, 129, 124),
                ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[300]!,
                style: BorderStyle.solid,
                width: 0.75,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 54, 126, 56),
                style: BorderStyle.solid,
                width: 1.5,
              ),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
          style: const TextStyle(),
          validator: validator,
        ),
      ],
    );
  }
}
