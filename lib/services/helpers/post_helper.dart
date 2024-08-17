import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as https;
import '../../models/request/post/post_comment_request.dart';
import '../../models/response/image_upload/image_upload.dart';
import '../../models/response/posts/create_post_response.dart';
import '../../models/response/posts/delete_post_response.dart';
import '../../models/response/posts/fetch_all_post_response.dart';
import '../../models/response/posts/fetch_one_post_response.dart';
import '../../models/response/posts/post_comment_response.dart';
import '../../models/result/image/image_upload_result.dart';
import '../../models/result/post/delete_post_result.dart';
import '../../models/result/post/create_post_result.dart';
import '../../models/result/post/fetch_all_post_result.dart';
import '../../models/result/post/fetch_one_post_result.dart';
import '../../models/result/post/post_comment_result.dart';
import '../config.dart';
import '../../models/request/post/create_post_request.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class PostHelper {

  static var client = https.Client();

  //########################## Upload Image to the API to get image path #####################################
  static Future<ImageUploadResult> uploadImage(File image, String accessToken, String tokenType) async {
    var url = Uri.parse('${Config.apiUrl}/post/image');
    var request = https.MultipartRequest('POST', url);

    // header
    Map<String, String> headers = {
      'Authorization': '$tokenType $accessToken',
      'Content-Type': 'multipart/form-data',
    };

    request.headers.addAll(headers);

    // Add the image file to the request
    request.files.add(await https.MultipartFile.fromPath('image', image.path));
    // print("Image file: ${image.path}");
    // print("Headers: $headers");

    try {
      var streamedResponse = await request.send();
      var response = await https.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ImageUploadResult.success(
          ImageUploadResponse.fromJson(jsonDecode(response.body)),
          response.statusCode,
        );
      } else {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        return ImageUploadResult.failure(
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      print('Image upload failed: $e');
      return ImageUploadResult.failure(500, 'Failed to upload image: $e');
    }
  }



  //################################### Create a new post ###################################
static Future<CreatePostResult> createPost(File image, String caption, context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  // Check if the user is logged in
  if (!userProvider.isLoggedIn) {
    return CreatePostResult.failure(401, 'User is not logged in');
  }

  String accessToken = userProvider.accessToken!;
  String creatorId = userProvider.userId!.toString();
  String tokenType = userProvider.tokenType!;

  // Upload the image first
  ImageUploadResult imageUploadResult = await uploadImage(image, accessToken, tokenType);


  if (imageUploadResult.statusCode != 200) {
    return CreatePostResult.failure(imageUploadResult.statusCode, imageUploadResult.error!);
  }


  //Get the uploaded image path 
  String imageUrl = imageUploadResult.response!.filename;

  // Create the post request with the image URL
  CreatePostRequest postRequest = CreatePostRequest(
    imageUrl: imageUrl,
    caption: caption,
    imageUrlType: "relative",
    creatorId: creatorId,
  );

  try {
    // Create a new post
    var url = Uri.parse('${Config.apiUrl}/post');

    var body = postRequest.toJson();

    var response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$tokenType $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CreatePostResult.successSingle(
        CreatePostResponse.fromJson(jsonDecode(response.body)),
        response.statusCode,
      );
    } else {
      return CreatePostResult.failure(
        response.statusCode,
        response.body,
      );
    }
  } catch (e) {
    print('Post creation failed: $e');
    return CreatePostResult.failure(500, 'Failed to create post: $e');
  }
}


  //################## Fetch a specific post by ID ##############
  static Future<FetchOnePostResult> fetchOnePost(int postId) async {
    var url = Uri.parse('${Config.apiUrl}/post/$postId');

    try {
      // Send the GET request without authentication headers
      var response = await client.get(url);

      if (response.statusCode == 200) {
        return FetchOnePostResult.success(
          FetchOnePostResponse.fromJson(jsonDecode(response.body)),
          response.statusCode,
        );
      } else {
        return FetchOnePostResult.failure(
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      return FetchOnePostResult.failure(500, 'Failed to fetch post: $e');
    }
  }



  //############################## Mthod to Fetch all posts ###############################
static Future<FetchAllPostResult> getAllPosts() async {
    var url = Uri.parse('${Config.apiUrl}/post/all');

    try {
        var response = await client.get(url);

        if (response.statusCode == 200) {
            List<dynamic> data = jsonDecode(response.body);

            List<FetchAllPostResponse> posts = data.map((post) => FetchAllPostResponse.fromJson(post)).toList();
            
            return FetchAllPostResult.success(posts, response.statusCode);
        } else {
            return FetchAllPostResult.failure(response.statusCode, response.body);
        }
    } catch (e) {
        return FetchAllPostResult.failure(500, 'Failed to fetch posts: $e');
    }
}




//#################### Method to delete a post ############################
static Future<DeletePostResult> deletePost(int postId, String accessToken, String tokenType, String currentUsername) async {
  var url = Uri.parse('${Config.apiUrl}/post/delete/$postId');

  // Fetch the post details first to check if the user is the owner
  var fetchResponse = await fetchOnePost(postId);
  if (fetchResponse.statusCode != 200 || fetchResponse.response == null) {
    return DeletePostResult.failure(fetchResponse.statusCode, 'Post not found');
  }

  // Check if the username matches the current logged-in user
  if (fetchResponse.response!.user.username != currentUsername) {
    return DeletePostResult.failure(403, 'User is not the owner of the post');
  }

  // Headers for the request
  Map<String, String> headers = {
    'Authorization': '$tokenType $accessToken',
    'Content-Type': 'application/json',
  };

  try {
    // Send the delete request
    var response = await client.delete(url, headers: headers);

    if (response.statusCode == 200) {
      // If the response is a JSON string, parse it as a map
      var responseData = jsonDecode(response.body);
      if (responseData is String) {
        return DeletePostResult.success(
          DeletePostResponse(message: responseData),
          response.statusCode,
        );
      } else {
        return DeletePostResult.success(
          DeletePostResponse.fromJson(responseData),
          response.statusCode,
        );
      }
    } else {
      return DeletePostResult.failure(
        response.statusCode,
        response.body,
      );
    }
  } catch (e) {
    print('Failed to delete post: $e');
    return DeletePostResult.failure(500, 'Failed to delete post: $e');
  }
}


// #################### Comment function  ##############################
  static Future<PostCommentResult> postComment(PostCommentRequest commentRequest, String accessToken, String tokenType) async {
    var url = Uri.parse('${Config.apiUrl}/comment');

    // Headers for the request
    Map<String, String> headers = {
      'Authorization': '$tokenType $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      // Send the POST request
      var response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(commentRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Comment was successfull----------------------");
        print(response.body);
        return PostCommentResult.success(
          PostCommentResponse.fromJson(jsonDecode(response.body)),
          response.statusCode,
        );
      } else {
        return PostCommentResult.failure(
          response.statusCode,
          response.body,
        );
      }
    } catch (e) {
      return PostCommentResult.failure(500, 'Failed to post comment: $e');
    }
  }



}



