import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../models/result/post/create_post_result.dart';
import '../../../services/helpers/post_helper.dart';

class CreatePostModal extends StatefulWidget {
  final VoidCallback onPostCreated;

  const CreatePostModal({super.key, required this.onPostCreated});  // Refactored to use super.key

  @override
  State<CreatePostModal> createState() => _CreatePostModalState();
}



class _CreatePostModalState extends State<CreatePostModal> with SingleTickerProviderStateMixin {
  final TextEditingController _captionController = TextEditingController();
  File? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Animation controller for easing in and out
  late AnimationController _animationController;
  late Animation<double> _heightFactor;
  

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    
  }

  

  @override
  void dispose() {
    _captionController.dispose();
    _animationController.dispose();
    super.dispose();
  }


  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  Future<void> _submitPost() async {
  if (_image == null || _captionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Image and caption are required")),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  CreatePostResult postResult = await PostHelper.createPost(
    _image!,
    _captionController.text,
    context,
  );

  if (mounted) {
    setState(() {
      _isLoading = false;
    });

    if (postResult.statusCode == 200 || postResult.statusCode == 201) {
      widget.onPostCreated(); // Call the callback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post created successfully!")),
      );
      

      // Dismiss the modal after a short delay to ensure the refresh happens
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create post: ${postResult.error}")),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightFactor,
      builder: (context, child) {
        return FractionallySizedBox(
          heightFactor: _heightFactor.value,
          alignment: Alignment.bottomCenter,
          child: child,
        );
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _animationController.reverse().then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ),
                    TextField(
                      controller: _captionController,
                      decoration: const InputDecoration(
                        labelText: 'Caption',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: _image == null
                            ? Icon(Icons.camera_alt, color: Colors.grey[800])
                            : Image.file(_image!, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitPost,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Post'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void showCreatePostModal(BuildContext context, VoidCallback onPostCreated) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) => CreatePostModal(
      onPostCreated: onPostCreated,
    ),
  );
}
