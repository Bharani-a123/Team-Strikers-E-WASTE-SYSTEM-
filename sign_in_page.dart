import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome Back!\nSign In',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // TODO: Implement Forgot Password
              },
              child: Text('Forgot Password?'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Sign In
              },
              child: Text('SIGN IN'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.redAccent,
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                // TODO: Navigate to Sign Up Page
              },
              child: Text("Don't have an account? Sign up"),
            ),
            SizedBox(height: 20),
            Text('Or Sign In with', textAlign: TextAlign.center),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 32),
                  onPressed: () {
                    // TODO: Implement Google Sign-In
                  },
                ),
                IconButton(
                  icon: Icon(Icons.facebook, color: Colors.blue, size: 32),
                  onPressed: () {
                    // TODO: Implement Facebook Sign-In
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
