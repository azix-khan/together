import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/home/presentation/components/my_drawer_tile.dart';
import 'package:together/features/search/presentation/pages/search_page.dart';

import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            // logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            // divider line
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),

            // home tile
            MyDrawerTile(
              title: "H O M E",
              icon: Icons.home,
              onTap: () => Navigator.of(context).pop(),
            ),

            // profile tile
            MyDrawerTile(
              title: "P R O F I L E",
              icon: Icons.person_2_outlined,
              onTap: () {
                // pop menu drawer
                Navigator.of(context).pop();

                // get curent user id
                final user = context.read<AuthCubit>().currentUser;
                String? uid = user!.uid;

                // naviagate to profile page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      uid: uid,
                    ),
                  ),
                );
              },
            ),

            // search tile
            MyDrawerTile(
              title: "S E A R C H",
              icon: Icons.search,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              ),
            ),

            // settings tile
            MyDrawerTile(
              title: "S E T T I N G S",
              icon: Icons.settings,
              onTap: () {},
            ),

            const Spacer(),

            // logout
            MyDrawerTile(
              title: "L O G O U T",
              icon: Icons.logout,
              onTap: () => context.read<AuthCubit>().logout(),
            ),
          ],
        ),
      )),
    );
  }
}
