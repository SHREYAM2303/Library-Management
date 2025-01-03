import 'package:flutter/material.dart';
import 'auth_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Enter your email"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authService.forgotPassword(emailController.text);
                Navigator.pop(context);
              },
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
