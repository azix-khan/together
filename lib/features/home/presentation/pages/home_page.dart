import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/home/presentation/components/my_drawer.dart';
import 'package:together/features/post/presentation/components/post_tile.dart';
import 'package:together/features/post/presentation/cubits/post_states.dart';
import 'package:together/responsive/constrained_scaffold.dart';

import '../../../post/presentation/cubits/post_cubit.dart';
import '../../../post/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // grab post cubit
  late final postCubit = context.read<PostCubit>();

  // on start up
  @override
  void initState() {
    super.initState();

    // fetch all posts
    fetchAllPosts();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  // delete post mthod
  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return ConstrainedScaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload new post button
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadPostPage()),
            ),
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      // DRAWER
      drawer: const MyDrawer(),

      // BODY
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          // loading...
          if (state is PostsLoading && state is PostUploading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Posts loading ..."),
                ],
              ),
            );
          }

          // loaded

          else if (state is PostsLoaded) {
            final allPosts = state.posts;

            if (allPosts.isEmpty) {
              return const Center(
                child: Text("No post available!"),
              );
            }
            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                // get individual posts on the big list
                final post = allPosts[index];

                // get image
                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }

          // error
          else if (state is PostsError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
