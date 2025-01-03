import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                var user = await _authService.signUp(
                  emailController.text,
                  passwordController.text,
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  print('Sign Up failed');
                }
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
