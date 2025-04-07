import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ewaste_manager/screens/home_screen.dart';
import 'package:ewaste_manager/screens/auth/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String email = '', password = '', confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Create Your Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/app_logo.jpg',
              height: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign up to get started',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),

            // Email Field
            _buildInputField(
              label: "Email",
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
            ),
            const SizedBox(height: 16),

            // Password Field
            _buildInputField(
              label: "Password",
              hintText: "Enter your password",
              obscureText: _obscurePassword,
              onChanged: (value) => password = value,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password Field
            _buildInputField(
              label: "Confirm Password",
              hintText: "Re-enter your password",
              obscureText: _obscureConfirmPassword,
              onChanged: (value) => confirmPassword = value,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            const SizedBox(height: 24),

            // Sign Up Button
            ElevatedButton(
              onPressed: _handleSignup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Create Account', style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 16),

            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () => _signInWithGoogle(context),
              icon: Image.asset(
                'assets/images/google_logo.png',
                height: 24,
                width: 24,
              ),
              label: const Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 16),

            // Already have an account?
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text(
                'Already have an account? Log in',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required Function(String) onChanged,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  void _handleSignup() async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorToast('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      _showErrorToast('Passwords do not match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Confirm that the user is not null
      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: 'Signup successful!');

        // Check if context is still mounted before navigating
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorToast('The password is too weak');
      } else if (e.code == 'email-already-in-use') {
        _showErrorToast('The account already exists for that email');
      } else {
        _showErrorToast('Signup failed: ${e.message}');
      }
    } catch (e) {
      _showErrorToast('An unexpected error occurred');
    }
  }


  Future<void> _signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
