import 'package:bluestone_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Store the user data in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', nameController.text);
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Created! Please Log In.')),
      );

      Navigator.pop(context);
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
              height: 250,
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
                  const SizedBox(height: 120),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create your account to get started!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
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
                            controller: nameController,
                            labelText: 'Name',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 20),
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
                                  onPressed: signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorClass.darkBlue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 80),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
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
