import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/request/post/post_comment_request.dart';
import '../../../models/response/posts/post_comment_response.dart';
import '../../../models/result/post/post_comment_result.dart';
import '../../../providers/post_provider.dart';
import '../../../services/helpers/post_helper.dart';
import '../../../providers/user_provider.dart';
import '../../../utils/date_helper.dart';
import 'login_modal.dart';

class CommentModal extends StatefulWidget {
  final int postId;
  final List<PostCommentResponse> comments;

  const CommentModal({
    super.key, 
    required this.postId,
    required this.comments,
  });

  @override
  State<CommentModal> createState() => _CommentModalState();
}


class _CommentModalState extends State<CommentModal> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

Future<void> _submitComment(String text) async {
    if (text.isEmpty) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    // Prepare the comment request
    PostCommentRequest request = PostCommentRequest(
      username: userProvider.username!,
      text: text,
      postId: widget.postId,
    );

    setState(() {
      _isLoading = true;
    });

    // Post the comment
    PostCommentResult result = await PostHelper.postComment(
      request,
      userProvider.accessToken!,
      userProvider.tokenType!,
    );

    if (result.statusCode == 200 || result.statusCode == 201) {
      setState(() {
        widget.comments.add(result.response!);
        // Update the post with the new comment
        postProvider.addCommentToPost(widget.postId, result.response!);
        _commentController.clear(); // Clear the text field
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: ${result.error}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      var comment = widget.comments[index];
                      DateTime timestamp = DateTime.parse(comment.timestamp);

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        ),
                        title: Row(
                          children: [
                            Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Text(
                              DateHelper.formatTimeAgo(timestamp),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        subtitle: Text(comment.text),
                        trailing: const Column(
                          children: [
                            Icon(Icons.favorite_border),
                            Text('0'), // Placeholder for like count
                          ],
                        ),
                      );
                    },
                  ),
                ),
// show comment field if user is logged in, otherwise prompt to log in
Padding(
  padding: const EdgeInsets.all(10.0),
  child: Row(
    children: [
      if (userProvider.isLoggedIn) ...[
        const CircleAvatar(
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
            onSubmitted: (text) {
              _submitComment(text);
            },
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: _isLoading
              ? const CircularProgressIndicator()
              : const Icon(Icons.send),
          onPressed: () {
            if (!_isLoading) {
              _submitComment(_commentController.text);
            }
          },
        ),
      ] else ...[
        Expanded(
          child: Center(
            child: Text(
              'You need to log in to comment.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    ],
  ),
)

              ],
            ),
          ),
        );
      },
    );
  }
}

