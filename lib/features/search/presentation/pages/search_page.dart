import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/profile/presentation/components/user_tile.dart';
import 'package:together/features/search/presentation/cubits/search_cubit.dart';
import 'package:together/features/search/presentation/cubits/search_states.dart';
import 'package:together/responsive/constrained_scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController seachController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = seachController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    seachController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    seachController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return ConstrainedScaffold(
      // APP BAR
      appBar: AppBar(
        // search text field
        title: TextField(
          controller: seachController,
          decoration: InputDecoration(
            hintText: "Search users ...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),

      // SEARCH RESULTS
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no users..
            if (state.users.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            // users..
            ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              },
            );
          }

          // loading ...
          else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // error ...
          else if (state is SearchError) {
            return Center(child: Text(state.message));
          }

          // default
          return const Center(child: Text("Start searching for users.."));
        },
      ),
    );
  }
}
