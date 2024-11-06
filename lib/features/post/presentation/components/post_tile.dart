import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/domain/entities/app_user.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:together/features/post/domain/entities/post.dart';
import 'package:together/features/post/presentation/cubits/post_cubit.dart';
import 'package:together/features/profile/domain/entities/profile_user.dart';
import 'package:together/features/profile/presentation/cubits/profile_cubit.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeletePressed;
  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // cubits
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // dont delete other posts
  bool isOwnPost = false;

  // current user
  AppUser? currentUser;

  // post user
  ProfileUser? postUser;

  // on startups
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    // check if its own post or not
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  // user tapped the like button
  void toggleLikePost() {
    // grad the current like status
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    // update the like
    postCubit.toggleLikePost(widget.post.id, currentUser!.uid);
  }

  // show opptions on deletion
  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post?"),
        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          // dellete button
          TextButton(
            onPressed: () {
              widget.onDeletePressed!();
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          // Top section of the post: profile / name / delete button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // prfile pic
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),

                const SizedBox(
                  width: 10,
                ),

                // name
                Text(
                  widget.post.userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                // delete button
                if (isOwnPost)
                  GestureDetector(
                    onTap: showOptions,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          // image
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const SizedBox(height: 430),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          // buttons - like, comment, timestemp
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // like button
                GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                ),

                // count of likes
                Text("0"),

                const SizedBox(
                  width: 20,
                ),

                // comment button
                Icon(Icons.comment),

                // count of comments
                Text("0"),

                const Spacer(),

                // timestemp
                Text(widget.post.timestamp.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
