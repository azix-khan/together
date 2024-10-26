import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/data/firebase_auth_repo.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:together/features/auth/presentation/cubits/auth_state.dart';
import 'package:together/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:together/features/storage/data/firebase_storage_repo.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/profile/data/firebase_profile_repo.dart';
import 'themes/light_mode.dart';

class MyApp extends StatelessWidget {
  // get auth repo
  final firebaseAuthRepo = FirebaseAuthRepo();
  // get profile repo
  final firebaseProfileRepo = FirebaseProfileRepo();
  // get storage repo
  final firebaseStorageRepo = FirebaseStorageRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubits to app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
      ],
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
