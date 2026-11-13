import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

class AuthScreen extends StatefulWidget {
  final AuthService auth;
  const AuthScreen({super.key, required this.auth});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signUp = false;
  bool _busy = false;
  bool _showPassword = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      setState(() => _error = 'Please fill in email and password.');
      return;
    }
    if (!_email.text.contains('@')) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    if (_signUp && _password.text.length < 6) {
      setState(() => _error = 'Password should be at least 6 characters.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (_signUp) {
        await widget.auth.signUp(_email.text, _password.text);
      } else {
        await widget.auth.signIn(_email.text, _password.text);
      }
    } catch (e) {
      if (mounted) setState(() => _error = AuthService.friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7ED), Color(0xFFF0F9FF), Color(0xFFECFDF5)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x180F172A),
                        blurRadius: 22,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFF97316), Color(0xFFF59E0B)],
                          ),
                        ),
                        child: Column(
                          children: [
                            const MascotOwl(emotion: OwlEmotion.welcome, size: 92),
                            const SizedBox(height: 7),
                            Text('SmartKid Insight', style: sinhalaText(25, color: Colors.white, weight: FontWeight.w900)),
                            Text(
                              'Sinhala Early Literacy & Cognitive Screening',
                              textAlign: TextAlign.center,
                              style: sinhalaText(10.5, color: const Color(0xFFFFF7ED)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(14)),
                              child: Row(
                                children: [
                                  _modeButton('Sign In', !_signUp, () => setState(() { _signUp = false; _error = null; })),
                                  _modeButton('Sign Up', _signUp, () => setState(() { _signUp = true; _error = null; })),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(_signUp ? 'Create a parent account' : 'Welcome back!', style: sinhalaText(18, weight: FontWeight.w900)),
                            Text(_signUp ? 'Register to create and manage child profiles.' : 'Sign in to continue to SmartKid Insight.', style: sinhalaText(11.5, color: AppColors.inkSoft)),
                            const SizedBox(height: 15),
                            TextField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.mail_outline), filled: true, fillColor: Color(0xFFF8FAFC)),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _password,
                              obscureText: !_showPassword,
                              autofillHints: const [AutofillHints.password],
                              onSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _showPassword = !_showPassword),
                                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                                ),
                              ),
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(color: const Color(0xFFFEF2F2), border: Border.all(color: const Color(0xFFFECACA)), borderRadius: BorderRadius.circular(12)),
                                child: Text(_error!, style: sinhalaText(11.5, color: AppColors.weak)),
                              ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _busy ? null : _submit,
                                child: _busy
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_signUp ? 'Create Account & Start' : 'Sign In'), const SizedBox(width: 8), const Icon(Icons.arrow_forward, size: 18)]),
                              ),
                            ),
                            const SizedBox(height: 13),
                            const Divider(height: 28, color: Color(0xFFEFF2F7)),
                            Row(children: [const Icon(Icons.auto_awesome, color: Color(0xFFF59E0B), size: 17), const SizedBox(width: 6), Text('Quick Demo Quick Roles:', style: sinhalaText(11, color: AppColors.inkSoft, weight: FontWeight.w900))]),
                            const SizedBox(height: 9),
                            Row(children: [
                              _roleChip('Parent'), const SizedBox(width: 6),
                              _roleChip('Teacher'), const SizedBox(width: 6),
                              _roleChip('Researcher'),
                            ]),
                            const SizedBox(height: 9),
                            Text(
                              _signUp ? 'Self-registration is available for parent accounts only.' : 'Use your authorised Firebase account. Teacher and researcher access is provisioned by the research team.',
                              textAlign: TextAlign.center,
                              style: sinhalaText(9.5, color: AppColors.inkSoft),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _roleChip(String role) => Expanded(child: OutlinedButton(
    onPressed: () => showDialog<void>(context: context, builder: (context) => AlertDialog(
      title: Text('$role access', style: sinhalaText(17, weight: FontWeight.w900)),
      content: Text(role == 'Parent' ? 'Parents can register using the Sign Up tab and manage their child profiles.' : '$role accounts must be created or authorised by the research team. Please sign in with your assigned Firebase account.', style: sinhalaText(12, color: AppColors.inkSoft)),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
    )),
    style: OutlinedButton.styleFrom(backgroundColor: const Color(0xFFF1F5F9), foregroundColor: AppColors.ink, side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
    child: Text(role, style: sinhalaText(10, weight: FontWeight.w600)),
  ));

  Widget _modeButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected ? const [BoxShadow(color: Color(0x10000000), blurRadius: 5)] : null,
          ),
          child: Text(label, textAlign: TextAlign.center, style: sinhalaText(11.5, weight: FontWeight.w900, color: selected ? AppColors.ink : AppColors.inkSoft)),
        ),
      ),
    );
  }
}
