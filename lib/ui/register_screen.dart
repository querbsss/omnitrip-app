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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _auth = AuthService();
  final _session = SessionService();

  bool _busy = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final result = await _auth.register(
      name: _nameCtrl.text,
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
          content: Text(result.message ?? 'Registration failed'),
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
                    AppColors.bgSurface.withValues(alpha: 0.5),
                    AppColors.bgSurface.withValues(alpha: 0.75),
                    AppColors.bgSurface.withValues(alpha: 0.5),
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
                      const FaqButton(screenKey: 'register', subtle: true),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 4),
                          _BrandHeader(),
                          const SizedBox(height: 18),
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Create account', style: AppType.headlineLg),
                                const SizedBox(height: 6),
                                Text(
                                  'Plan your first smart trip in minutes.',
                                  style: AppType.bodySm,
                                ),
                                const SizedBox(height: 22),
                                _InputLabel(label: 'Full Name'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nameCtrl,
                                  decoration: InputDecoration(
                                    hintText: 'Your name',
                                    prefixIcon: Icon(
                                      Symbols.person_rounded,
                                      color: AppColors.outline,
                                    ),
                                  ),
                                  validator: (v) =>
                                      Validators.required(v, 'Name'),
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 14),
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
                                const SizedBox(height: 14),
                                _InputLabel(label: 'Password'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscure1,
                                  decoration: InputDecoration(
                                    hintText: 'At least 6 characters',
                                    prefixIcon: Icon(
                                      Symbols.lock_rounded,
                                      color: AppColors.outline,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure1
                                            ? Symbols.visibility_rounded
                                            : Symbols.visibility_off_rounded,
                                        color: AppColors.outline,
                                      ),
                                      onPressed: () => setState(
                                          () => _obscure1 = !_obscure1),
                                    ),
                                  ),
                                  validator: Validators.password,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 14),
                                _InputLabel(label: 'Confirm Password'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _confirmCtrl,
                                  obscureText: _obscure2,
                                  decoration: InputDecoration(
                                    hintText: 'Re-enter your password',
                                    prefixIcon: Icon(
                                      Symbols.lock_rounded,
                                      color: AppColors.outline,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscure2
                                            ? Symbols.visibility_rounded
                                            : Symbols.visibility_off_rounded,
                                        color: AppColors.outline,
                                      ),
                                      onPressed: () => setState(
                                          () => _obscure2 = !_obscure2),
                                    ),
                                  ),
                                  validator: (v) =>
                                      Validators.match(v, _passCtrl.text),
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                                const SizedBox(height: 24),
                                PillButton(
                                  label: 'Create Account',
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
                                      '/login',
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    child: RichText(
                                      text: TextSpan(
                                        style: AppType.bodySm.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Already registered? ',
                                          ),
                                          TextSpan(
                                            text: 'Log In',
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.brandPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppColors.ctaGlow,
          ),
          alignment: Alignment.center,
          child: Icon(
            Symbols.auto_awesome_rounded,
            color: AppColors.onBrand,
            size: 28,
            fill: 1,
          ),
        ),
        const SizedBox(height: 10),
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
