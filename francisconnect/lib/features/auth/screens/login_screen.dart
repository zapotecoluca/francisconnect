import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:francisconnect/core/common/buttons.dart';
import 'package:francisconnect/core/constants/constants.dart';
import 'package:francisconnect/theme/palette.dart';
import 'package:francisconnect/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override

   void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }
    ref.read(authControllerProvider.notifier).signIn(
          email: email,
          password: password,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:  SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Palette.primary,
                  padding: const EdgeInsets.symmetric(vertical:48),
                  child: Column(
                    children: [
                      Image.asset(Constants.whiteLogoPath,
                      height: 70,),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Palette.whiteColor,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        const SizedBox(height: 24,),

                        TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Correo institucional',
                              hintText: 'xxxxx@ufg.edu.sv',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                          ),
                        const SizedBox(height: 16),

                        TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _login(),
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.tertiary,
                              foregroundColor: Palette.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                            ),
                          child: isLoading
                            ?const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Palette.whiteColor,
                              ),
                            )
                            : const Text('Ingresar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ), 
                        const SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            goToSignUpBtn()
                          ],
                        )                       
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

