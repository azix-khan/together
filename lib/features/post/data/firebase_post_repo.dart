import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:together/features/post/domain/entities/post.dart';
import 'package:together/features/post/domain/repository/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // store posts in a collection called 'posts'
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  Future<void> createPost(Post post) async {
    try {
      // go to post collection and set post to json
      await postsCollection.doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception("Error creating post: $e");
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      // goto the collection and delete that post
      await postsCollection.doc(postId).delete();
    } catch (e) {
      throw Exception("Error deleting post: $e");
    }
  }

  @override
  Future<List<Post>> fetchAllPosts() async {
    try {
      // get all posts with the most recent post at the top
      final postsSnapshot =
          await postsCollection.orderBy('timestamp', descending: true).get();

      // convert each firestore doc fron json to list of post
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allPosts;
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      // fetch posts snapshot with this uid
      final postsSnapshot =
          await postsCollection.where('userId', isEqualTo: userId).get();

      // convert firestore doc from json to list of posts
      final userPosts = postsSnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return userPosts;
    } catch (e) {
      throw Exception("Error fetching posts by user: $e");
    }
  }
}
