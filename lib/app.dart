import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/data/firebase_auth_repo.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:together/features/auth/presentation/cubits/auth_state.dart';
import 'package:together/features/post/data/firebase_post_repo.dart';
import 'package:together/features/post/presentation/cubits/post_cubit.dart';
import 'package:together/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:together/features/search/data/firebase_search_repo.dart';
import 'package:together/features/search/presentation/cubits/search_cubit.dart';
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
  // get post repo
  final firebasepostRepo = FirebasePostRepo();
  // search repo
  final firebaseSearchRepo = FirebaseSearchRepo();

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
        // post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasepostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        // search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
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
