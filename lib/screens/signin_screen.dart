import 'package:anime_verse/providers/auth_notifier.dart';
import 'package:anime_verse/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/routes.dart';
import '../widgets/app_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      SnackBarHelper.show(context, 'Email dan password wajib diisi');
      return;
    }

    final auth = context.read<AuthNotifier>();
    final success = await auth.signIn(email, password);

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    } else {
      SnackBarHelper.show(context, auth.errorMessage ?? 'Sign in gagal');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final auth = context.read<AuthNotifier>();
    final success = await auth.signInWithGoogle();

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    } else if (auth.errorMessage != null) {
      SnackBarHelper.show(context, auth.errorMessage!);
    }
  }

  Future<void> _handleForgotPassword() async {
    final resetController = TextEditingController(
      text: _emailController.text.trim(),
    );
    final email = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: resetController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Masukkan email terdaftar',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, resetController.text.trim()),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (email == null || email.isEmpty) return;
    if (!mounted) return;

    final auth = context.read<AuthNotifier>();
    final success = await auth.sendPasswordResetEmail(email);

    if (!mounted) return;

    if (success) {
      SnackBarHelper.show(
        context,
        'Link reset password dikirim ke $email',
        isError: false,
      );
    } else {
      SnackBarHelper.show(
        context,
        auth.errorMessage ?? 'Gagal mengirim link reset password',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isLoading = context.watch<AuthNotifier>().isLoading;

    return AppScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth > 600;
          final maxWidth = isLargeScreen ? 400.0 : constraints.maxWidth;
          final baseWidth = maxWidth;

          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: maxWidth,
                padding: EdgeInsets.all(baseWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.06),

                    // Title
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: baseWidth * 0.08,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      'Sign in to continue your anime journey',
                      style: TextStyle(
                        fontSize: baseWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Email TextField
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: baseWidth * 0.04,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(baseWidth * 0.03),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white70,
                          size: baseWidth * 0.06,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: baseWidth * 0.05,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: baseWidth * 0.04,
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Password TextField
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: baseWidth * 0.04,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(baseWidth * 0.03),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.white70,
                          size: baseWidth * 0.06,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white70,
                            size: baseWidth * 0.06,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: baseWidth * 0.05,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: baseWidth * 0.04,
                        color: Colors.white,
                      ),
                      obscureText: _obscurePassword,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading ? null : _handleForgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: baseWidth * 0.035,
                            color: Colors.blue.shade300,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withValues(alpha: 0.8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              baseWidth * 0.03,
                            ),
                          ),
                          elevation: 5,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: baseWidth * 0.045,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Divider "or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: baseWidth * 0.03,
                          ),
                          child: Text(
                            'or',
                            style: TextStyle(
                              fontSize: baseWidth * 0.035,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Sign in with Google
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _handleGoogleSignIn,
                        icon: SvgPicture.asset(
                          'assets/images/google_icon.svg',
                          height: baseWidth * 0.06,
                          width: baseWidth * 0.06,
                        ),
                        label: Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: baseWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              baseWidth * 0.03,
                            ),
                            side: const BorderSide(
                              color: Colors.black45,
                              width: 1,
                            ),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Sign up link
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: baseWidth * 0.04,
                            color: Colors.white70,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.signUp);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: baseWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
