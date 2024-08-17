import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../widgets/mainscreen_appbar.dart';
import '../widgets/mainscreen_bottom_navbar.dart';
import '../widgets/post/post_list.dart';
import '../../../../providers/post_provider.dart'; // Import PostProvider

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kDarkBlue, 
      statusBarIconBrightness: Brightness.light, 
    ));

    // Fetch posts when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: Scaffold(
        appBar: MainscreenAppbar(),
        body: const PostList(),
        bottomNavigationBar: const BottomNavbar(),
      ),
    );
  }
}


