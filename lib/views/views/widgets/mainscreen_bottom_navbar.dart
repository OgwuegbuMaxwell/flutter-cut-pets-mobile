import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/post_provider.dart';
import '../../../providers/user_provider.dart';
import '../modals/login_modal.dart';
import '../modals/post_modal.dart';
import '../modals/signup_modal.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key}); // Use super.key to handle the key parameter

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    return BottomAppBar(
      color: kDarkBlue, // Matching the AppBar color
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: userProvider.isLoggedIn
              ? <Widget>[
                  IconButton(
                    onPressed: () {
                      // Handle create post action and pass the refresh function
                      showCreatePostModal(context, postProvider.refreshPosts);
                    },
                    icon: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [kNewBlue, kDarkBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        color: kLight,
                        size: 30.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Log out the user
                      userProvider.logout();
                    },
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: kLight, fontSize: 18.sp),
                    ),
                  ),
                ]
              : <Widget>[
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginModal(),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: kLight, fontSize: 18.sp),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const SignUpModal(),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: kLight, fontSize: 18.sp),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import '../../../constants/app_constants.dart';
// import '../../../providers/post_provider.dart';
// import '../../../providers/user_provider.dart';
// import '../modals/login_modal.dart';
// import '../modals/post_modal.dart';
// import '../modals/signup_modal.dart';
// class BottomNavbar extends StatelessWidget {
//   const BottomNavbar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final postProvider = Provider.of<PostProvider>(context, listen: false);

//     return BottomAppBar(
//       color: kDarkBlue, // Matching the AppBar color
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 8.0,
//       child: Container(
//         height: 60.h,
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: userProvider.isLoggedIn
//               ? <Widget>[
//                   IconButton(
//                     onPressed: () {
//                       // Handle create post action and pass the refresh function
//                       showCreatePostModal(context, postProvider.refreshPosts);
//                     },
//                     icon: Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [kNewBlue, kDarkBlue],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.add,
//                         color: kLight,
//                         size: 30.sp,
//                       ),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Log out the user
//                       userProvider.logout();
//                     },
//                     child: Text(
//                       'Log Out',
//                       style: TextStyle(color: kLight, fontSize: 18.sp),
//                     ),
//                   ),
//                 ]
//               : <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => const LoginModal(),
//                       );
//                     },
//                     child: Text(
//                       'Login',
//                       style: TextStyle(color: kLight, fontSize: 18.sp),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) => const SignUpModal(),
//                       );
//                     },
//                     child: Text(
//                       'Sign Up',
//                       style: TextStyle(color: kLight, fontSize: 18.sp),
//                     ),
//                   ),
//                 ],
//         ),
//       ),
//     );
//   }
// }
