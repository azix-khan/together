import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;

  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final paswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // when register button pressed
  void register() {
    // prepare info
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = paswordController.text;
    final String confirmPassword = confirmpasswordController.text;

    // auth cubit
    final authCubit = context.read<AuthCubit>();

    // ensure the fields are not empty
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      // ensure password match
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      }

      // password did not match
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password did not match!")));
      }
      // field are empty, display error
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill are the fields")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    paswordController.dispose();
    confirmpasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
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
              // create account msg
              Text(
                "Let's create an account for you!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              const SizedBox(
                height: 50,
              ),
              // name textfield
              MyTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
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
                height: 10,
              ),
              // confirm password textfield
              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm password',
                obscureText: true,
              ),
              const SizedBox(
                height: 25,
              ),
              // Register button
              MyButton(onTap: register, text: "Register"),
              const SizedBox(
                height: 50,
              ),
              // already a member? login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text(
                      " Login now",
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
