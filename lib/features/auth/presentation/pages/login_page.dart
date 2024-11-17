import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/presentation/components/my_button.dart';
import 'package:together/features/auth/presentation/components/my_text_field.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:together/responsive/constrained_scaffold.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final emailController = TextEditingController();
  final paswordController = TextEditingController();

  // login function
  void login() {
    // extracting text from controllers
    final String email = emailController.text;
    final String password = paswordController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure text fields are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      // login
      authCubit.login(email, password);
    } else {
      // display an error when fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the required fileds')));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    paswordController.dispose();
    super.dispose();
  }

// Build UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return ConstrainedScaffold(
      // BODY
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.lock_open_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 25,
              ),
              // welcome back msg
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              const SizedBox(
                height: 50,
              ),
              // email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              // password textfield
              MyTextField(
                controller: paswordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              // login button
              MyButton(onTap: login, text: "Login"),
              const SizedBox(
                height: 50,
              ),
              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      " Register now",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
