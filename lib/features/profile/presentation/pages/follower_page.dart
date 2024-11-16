import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/profile/presentation/components/user_tile.dart';
import 'package:together/features/profile/presentation/cubits/profile_cubit.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // TAB CONTROLLER
    return DefaultTabController(
      length: 2,

      //SCAFFOLD
      child: Scaffold(
        // APP BAR
        appBar: AppBar(
          // TAB BAR
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),

        // TAB BAR VIEW
        body: TabBarView(
          children: [
            _buildUserList(followers, "No Followers", context),
            _buildUserList(following, "No Following", context),
          ],
        ),
      ),
    );
  }

  // build user list, given a list of profile uids
  Widget _buildUserList(
      List<String> uids, String emptyMessage, BuildContext context) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              // get each uid
              final uid = uids[index];

              // get the user profile from these uids
              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  //user loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(user: user);
                  }

                  //user loading ..
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading ..."));
                  }

                  // not found !
                  else {
                    return const ListTile(title: Text("User Not Found !"));
                  }
                },
              );
            },
          );
  }
}
