import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../core/colors.dart';
import '../core/validators.dart';
import '../data/services/auth_service.dart';
import '../data/services/session_service.dart';
import 'widgets/animated_login_background.dart';
import 'widgets/faq_button.dart';
import 'widgets/pill_button.dart';
import 'widgets/theme_toggle_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();
  final _session = SessionService();

  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final result = await _auth.login(
      email: _emailCtrl.text,
      password: _passCtrl.text,
    );
    if (!mounted) return;
    if (result.status == AuthStatus.success && result.user != null) {
      await _session.saveSession(result.user!.email);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/planner', (_) => false);
    } else {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text(result.message ?? 'Login failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      appBar: AppBar(
        backgroundColor: AppColors.bgCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: const [
          FaqButton(screenKey: 'login'),
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: AnimatedLoginBackground()),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Transform.translate(
                      offset: const Offset(-3, 0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/login_page/logo/logo_omnitrip.png',
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
                      decoration: BoxDecoration(
                        color: AppColors.bgCream.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 18,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Log in to continue planning your trip.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'you@example.com',
                              prefixIcon: Icon(HugeIcons.strokeRoundedMail01),
                            ),
                            validator: Validators.email,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'At least 6 characters',
                              prefixIcon: const Icon(
                                HugeIcons.strokeRoundedSquareLock02,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? HugeIcons.strokeRoundedView
                                      : HugeIcons.strokeRoundedViewOffSlash,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: Validators.password,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 24),
                          PillButton(
                            label: 'Log In',
                            onPressed: _submit,
                            loading: _busy,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: AppColors.textMuted),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                ),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    color: AppColors.tealDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
