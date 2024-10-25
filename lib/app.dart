import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/data/firebase_auth_repo.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:together/features/auth/presentation/cubits/auth_state.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'themes/light_mode.dart';

class MyApp extends StatelessWidget {
  // get auth repo
  final authRepo = FirebaseAuthRepo();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubit to the app
    return BlocProvider(
      create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
      child: MaterialApp(
        theme: lightMode,
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            // if Unauthenticated go to the auth page (login/register)
            if (authState is UnAuthenticated) {
              return const AuthPage();
            }
            // if authenticate go to home page
            if (authState is Authenticated) {
              return const HomePage();
            }
            // loading
            else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          // listen for error while we log in
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
