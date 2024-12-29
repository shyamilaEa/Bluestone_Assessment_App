import 'package:bluestone_app/constants/colors.dart';
import 'package:bluestone_app/screens/product_list_screen/product_list_screen.dart';
import 'package:bluestone_app/screens/signup_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate a network call
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedEmail = prefs.getString('email');
      String? storedPassword = prefs.getString('password');

      if (emailController.text == storedEmail && passwordController.text == storedPassword) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductListPage()),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not registered. Please sign up.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                color: ColorClass.darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome back! Please login to your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextField(
                            controller: emailController,
                            labelText: 'Email',
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null ||
                                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          buildTextField(
                            controller: passwordController,
                            labelText: 'Password',
                            icon: Icons.lock,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorClass.darkBlue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 80),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpPage()),
                              );
                            },
                             child: RichText(
    text: const TextSpan(
      children: [
        TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        TextSpan(
          text: "Sign up",
          style: TextStyle(fontSize: 16, color:  ColorClass.darkBlue,), // Change to your desired color
        ),
      ],
    ),
  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: ColorClass.darkBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
