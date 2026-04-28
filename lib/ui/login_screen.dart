import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../core/colors.dart';
import '../core/typography.dart';
import '../core/validators.dart';
import '../data/services/auth_service.dart';
import '../data/services/session_service.dart';
import 'widgets/animated_login_background.dart';
import 'widgets/faq_button.dart';
import 'widgets/glass_card.dart';
import 'widgets/pill_button.dart';

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
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    } else {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFBA1A1A),
          behavior: SnackBarBehavior.floating,
          shape: const StadiumBorder(),
          content: Text(result.message ?? 'Login failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedLoginBackground()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.bgSurface.withValues(alpha: 0.4),
                    AppColors.bgSurface.withValues(alpha: 0.7),
                    AppColors.bgSurface.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Symbols.arrow_back_rounded,
                          color: AppColors.brandDeep,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const Spacer(),
                      const FaqButton(screenKey: 'login', subtle: true),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          _BrandHeader(),
                          const SizedBox(height: 24),
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Welcome back',
                                  style: AppType.headlineLg,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Log in to continue planning your trip.',
                                  style: AppType.bodySm,
                                ),
                                const SizedBox(height: 22),
                                _InputLabel(label: 'Email'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'you@example.com',
                                    prefixIcon: Icon(
                                      Symbols.mail_rounded,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  validator: Validators.email,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 16),
                                _InputLabel(label: 'Password'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    hintText: '••••••••',
                                    prefixIcon: Icon(
                                      Symbols.lock_rounded,
                                      color: AppColors.outline,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure
                                            ? Symbols.visibility_rounded
                                            : Symbols.visibility_off_rounded,
                                        color: AppColors.outline,
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
                                  icon: Symbols.arrow_forward_rounded,
                                  onPressed: _submit,
                                  loading: _busy,
                                ),
                                const SizedBox(height: 14),
                                Center(
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.pushReplacementNamed(
                                      context,
                                      '/register',
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    child: RichText(
                                      text: TextSpan(
                                        style: AppType.bodySm.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: "Don't have an account? ",
                                          ),
                                          TextSpan(
                                            text: 'Register',
                                            style: AppType.labelMd.copyWith(
                                              color: AppColors.brandDeep,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w800,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.ctaGlow,
          ),
          alignment: Alignment.center,
          child: Icon(
            Symbols.travel_explore_rounded,
            color: AppColors.onBrand,
            size: 30,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'OmniTrip',
          style: AppType.headlineXl.copyWith(letterSpacing: -0.6),
        ),
      ],
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String label;
  const _InputLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        label,
        style: AppType.labelMd.copyWith(color: AppColors.onSurface),
      ),
    );
  }
}
