import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/response/posts/fetch_all_post_response.dart';
import '../../../../providers/post_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/helpers/post_helper.dart';
import '../../../../utils/post_utils.dart';
import '../../../../utils/ui_utils.dart';
import 'post_item.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  Future<void> _refreshPosts(BuildContext context) async {
    await Provider.of<PostProvider>(context, listen: false).refreshPosts();
  }

  void _handleDeletePost(BuildContext context, int postId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!userProvider.isLoggedIn) {
      showSnackBar(context, 'You must be logged in to delete a post');
      return;
    }

    String accessToken = userProvider.accessToken!;
    String tokenType = userProvider.tokenType!;
    String currentUsername = userProvider.username!;

    showLoadingDialog(context);

    var result = await PostHelper.deletePost(postId, accessToken, tokenType, currentUsername);

    if (!context.mounted) return;

    Navigator.of(context).pop();

    if (result.statusCode == 200) {
      showSnackBar(context, 'Post deleted successfully');
      _refreshPosts(context); // Refresh the posts after deletion
    } else {
      showSnackBar(context, 'Failed to delete post: ${result.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: Provider.of<PostProvider>(context, listen: false).fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Consumer<PostProvider>(
            builder: (context, postProvider, child) {
              if (postProvider.posts.isEmpty) {
                return const Center(child: Text('No posts found'));
              }

              List<FetchAllPostResponse> sortedPosts = PostUtils.sortPostsByLatest(postProvider.posts);

              return RefreshIndicator(
                onRefresh: () => _refreshPosts(context),
                child: ListView.builder(
                  controller: postProvider.scrollController, // Use the provider's ScrollController
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  itemCount: sortedPosts.length,
                  itemBuilder: (context, index) {
                    var post = sortedPosts[index];
                    return PostItem(
                      post: post,
                      onLike: () {
                        // Handle Like action
                      },
                      onDelete: () {
                        _handleDeletePost(context, post.id);
                        postProvider.refreshPosts(); // Refresh the posts and scroll to the top
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}


