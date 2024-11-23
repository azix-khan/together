import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together/features/auth/domain/entities/app_user.dart';
import 'package:together/features/auth/presentation/components/my_text_field.dart';
import 'package:together/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:together/features/post/domain/entities/post.dart';
import 'package:together/features/post/presentation/cubits/post_cubit.dart';
import 'package:together/features/post/presentation/cubits/post_states.dart';
import 'package:together/responsive/constrained_scaffold.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  // mobile image pick
  PlatformFile? imagePickedFile;

  // web image pick
  Uint8List? webImage;

  // caption text controller
  final textController = TextEditingController();

  // keep track of the current user
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  // get Current user
  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  // pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );

    // we have results
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  // create & upload post
  void uploadPost() {
    // chech if both image and caption are provided
    if (imagePickedFile == null || textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Both image & caption are required")));
      return;
    }

    // create a new post object
    final newPost = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '',
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    // post cubit
    final postCubit = context.read<PostCubit>();

    // web upload
    if (kIsWeb) {
      postCubit.createPost(newPost, imageBytes: imagePickedFile?.bytes);
    }
    // mobile upload
    else {
      postCubit.createPost(newPost, imagePath: imagePickedFile?.path);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // BLOC CONSUMER -> builder + listner
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        // loading or uploading ...
        if (state is PostsLoading || state is PostUploading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Uploading post..."),
                ],
              ),
            ),
          );
        } else {
          // return upload page
          return buildUploadPage();
        }
      },

      // go to the previous page when the upload is done & the post are loaded
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    //SCAFFOLD
    return ConstrainedScaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text("Create post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(
              Icons.upload,
            ),
          ),
        ],
      ),

      // BODY
      body: Center(
        child: Column(
          children: [
            // image preview for the web
            if (kIsWeb && webImage != null) Image.memory(webImage!),

            // image preview for the mobile
            if (!kIsWeb && imagePickedFile != null)
              Image.file(File(imagePickedFile!.path!)),

            // pick image button
            MaterialButton(
              onPressed: pickImage,
              color: Colors.grey,
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 12),

            // caption text box

            MyTextField(
                controller: textController,
                hintText: "Write caption...",
                obscureText: false),
          ],
        ),
      ),
    );
  }
}
