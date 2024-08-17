import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../models/response/posts/fetch_all_post_response.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/config.dart';
import '../../../../utils/date_helper.dart';
import '../../modals/comment_modal.dart';

class PostItem extends StatefulWidget {
  final FetchAllPostResponse post;
  final Function onLike;
  final Function onDelete;

  const PostItem({
    super.key, 
    required this.post,
    required this.onLike,
    required this.onDelete,
  });
  
  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.post.imageUrlType == 'relative'
        ? '${Config.apiUrl}/${widget.post.imageUrl}'
        : widget.post.imageUrl;

    String avatarUrl = 'assets/avater/avatar-person.svg';

    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: SvgPicture.asset(
                  avatarUrl,
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateHelper.formatTimeAgo(widget.post.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildMoreOptionsSheet(context, widget.post),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (widget.post.caption.isNotEmpty)
            Text(widget.post.caption, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          if (widget.post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconTextButton(
                icon: FontAwesomeIcons.thumbsUp,
                label: 'Like',
                onTap: () => widget.onLike(),
              ),
              _buildIconTextButton(
                icon: FontAwesomeIcons.comment,
                label: 'Comment (${widget.post.comments.length})',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return CommentModal(
                        comments: widget.post.comments,
                        postId: widget.post.id,
                      );
                    },
                  ).then((_) {
                    // Force rebuild after the comment modal is closed
                    setState(() {});
                  });
                },
              ),
              _buildIconTextButton(
                icon: FontAwesomeIcons.share,
                label: 'Share',
                onTap: () {
                  // Handle Share action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconTextButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMoreOptionsSheet(BuildContext context, FetchAllPostResponse post) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool isOwner = userProvider.username == post.user.username;

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save Post'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (isOwner)
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Post'),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete();
              },
            ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../../../models/response/posts/fetch_all_post_response.dart';
// import '../../../../providers/user_provider.dart';
// import '../../../../services/config.dart';
// import '../../../../utils/date_helper.dart';
// import '../../modals/comment_modal.dart';


// class PostItem extends StatelessWidget {
//   final FetchAllPostResponse post;
//   final Function onLike;
//   final Function onDelete;

//   const PostItem({
//     Key? key,
//     required this.post,
//     required this.onLike,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String imageUrl = post.imageUrlType == 'relative'
//         ? '${Config.apiUrl}/${post.imageUrl}'
//         : post.imageUrl;

//     String avatarUrl = 'assets/avater/avatar-person.svg';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10.0),
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.grey.shade200,
//                 child: SvgPicture.asset(
//                   avatarUrl,
//                   width: 40,
//                   height: 40,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       post.user.username,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Text(
//                       DateHelper.formatTimeAgo(post.timestamp),
//                       style: const TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.more_horiz),
//                 onPressed: () {
//                   showModalBottomSheet(
//                     context: context,
//                     builder: (context) => _buildMoreOptionsSheet(context, post),
//                   );
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           if (post.caption.isNotEmpty)
//             Text(post.caption, style: const TextStyle(fontSize: 16)),
//           const SizedBox(height: 10),
//           if (post.imageUrl.isNotEmpty)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10.0),
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 // placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: 200,
//               ),
//             ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildIconTextButton(
//                 icon: FontAwesomeIcons.thumbsUp,
//                 label: 'Like',
//                 onTap: () => onLike(),
//               ),
//               _buildIconTextButton(
//                 icon: FontAwesomeIcons.comment,
//                 label: 'Comment (${post.comments.length})',
//                 onTap: () {
//                   showModalBottomSheet(
//                     context: context,
//                     isScrollControlled: true,
//                     backgroundColor: Colors.transparent,
//                     builder: (context) {
//                       return CommentModal(
//                         comments: post.comments,
//                         postId: post.id,
//                       );
//                     },
//                   );
//                 },
//               ),
//               _buildIconTextButton(
//                 icon: FontAwesomeIcons.share,
//                 label: 'Share',
//                 onTap: () {
//                   // Handle Share action
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIconTextButton({required IconData icon, required String label, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey),
//           const SizedBox(width: 5),
//           Text(label, style: const TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   Widget _buildMoreOptionsSheet(BuildContext context, FetchAllPostResponse post) {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     bool isOwner = userProvider.username == post.user.username;

//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: const Icon(Icons.save),
//             title: const Text('Save Post'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           if (isOwner)
//             ListTile(
//               leading: const Icon(Icons.delete),
//               title: const Text('Delete Post'),
//               onTap: () {
//                 Navigator.pop(context);
//                 onDelete();
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
