import 'package:flutter/material.dart';
import 'login_validator.dart';
import '../../services/auth_service.dart';
import '../register/register_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final message = await AuthService.loginUser(
        emailController.text,
        passwordController.text,
      );

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );

      if (message.toLowerCase().contains('success')) {
        // Navigate only on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/images/pizza_chef.png', width: 200),
                const SizedBox(height: 0),
                Transform.translate(
                  offset: Offset(0, -50),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Amerika'),
                      ),
                      const Text('Login with your verified credentials.')
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ), // or use Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25), // 🔹 Radius here
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, // 🔹 Controls height
                      horizontal: 12.0, // 🔹 Controls side padding
                    ),
                  ),
                  validator: LoginValidator.validateEmail,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ), // or use Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25), // 🔹 Radius here
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, // 🔹 Controls height
                      horizontal: 12.0, // 🔹 Controls side padding
                    ),
                  ),
                  validator: LoginValidator.validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: isLoading
                      ? Row(mainAxisAlignment: MainAxisAlignment.center ,children: [const CircularProgressIndicator(color: Colors.white), SizedBox(width: 15),const Text('Loading...', style: TextStyle(color: Colors.black45),)])
                      : const Text('Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3)),
                ),
                Row(
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        // Navigate to signup
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text('Sign Up'),
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
