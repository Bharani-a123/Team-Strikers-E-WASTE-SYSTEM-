import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ewaste_manager/screens/home_screen.dart';
import 'package:ewaste_manager/screens/auth/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', pass = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Image.asset(
              'assets/images/app_logo.jpg',
              height: 100,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Login to continue',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Email Field
            _buildInputField(
              label: "Email",
              hintText: "Enter your email",
              onChanged: (value) => email = value,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Password Field with visibility toggle
            _buildInputField(
              label: "Password",
              hintText: "Enter your password",
              onChanged: (value) => pass = value,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Add forgot password logic
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Login Button
            ElevatedButton(
              onPressed: () async {
                if (email.isEmpty || pass.isEmpty) {
                  _showErrorToast('Please enter both email and password');
                  return;
                }

                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } on FirebaseAuthException catch (e) {
                  switch (e.code) {
                    case 'invalid-email':
                      _showErrorToast('Invalid email address format.');
                      break;
                    case 'user-disabled':
                      _showErrorToast('This account has been disabled.');
                      break;
                    case 'user-not-found':
                    case 'wrong-password':
                      _showErrorToast('Incorrect email or password.');
                      break;
                    default:
                      _showErrorToast('Login failed: ${e.message}');
                  }
                } catch (e) {
                  _showErrorToast('An unexpected error occurred. Please try again.');
                }
              },


              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Match signup screen button
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 16)),
            ),


            const SizedBox(height: 20),

            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () async => await _signInWithGoogle(context),
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
                side: const BorderSide(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 24),

            // Sign Up Redirect
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
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
