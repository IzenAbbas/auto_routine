import 'package:auto_routine/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _obscurePassword = true;

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isLight ? primaryText[0] : primaryText[1],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscure,
          style: TextStyle(color: isLight ? primaryText[0] : primaryText[1]),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isLight ? secondaryText[0] : secondaryText[1],
            ),
            prefixIcon: Icon(
              icon,
              color: isLight ? secondaryText[0] : secondaryText[1],
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isLight ? secondaryAccent[0] : secondaryAccent[1],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isLight ? secondaryAccent[0] : secondaryAccent[1],
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryAccent, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLight ? appBackground[0] : appBackground[1],
      appBar: AppBar(
        backgroundColor: isLight ? appBackground[0] : appBackground[1],
        title: Text(
          'Sign In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLight ? primaryText[0] : primaryText[1],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: double.infinity),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: isLight ? primaryText[0] : primaryText[1],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Let's get you back to being productive.",
                      style: TextStyle(
                        color: isLight ? secondaryText[0] : secondaryText[1],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildField(
                label: 'Email Address',
                hint: 'Enter your email',
                icon: Icons.mail_outline,
              ),
              const SizedBox(height: 16),
              _buildField(
                label: 'Password',
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: isLight ? secondaryText[0] : secondaryText[1],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAccent,
                    foregroundColor: primaryText[0],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isLight ? secondaryText[0] : secondaryText[1],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        fontSize: 11,
                        color: isLight ? secondaryText[0] : secondaryText[1],
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isLight ? secondaryText[0] : secondaryText[1],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isLight
                        ? secondaryAccent[0]
                        : secondaryAccent[1],
                    foregroundColor: isLight
                        ? secondaryText[0]
                        : secondaryText[1],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: primaryAccent),
                  ),
                  icon: const Icon(FontAwesomeIcons.google),
                  label: const Text('Google'),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isLight ? secondaryText[0] : secondaryText[1],
                      ),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: primaryAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
