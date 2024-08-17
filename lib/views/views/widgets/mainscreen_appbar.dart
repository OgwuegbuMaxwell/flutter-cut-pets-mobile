import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/app_constants.dart';

class MainscreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  // Use super.key to handle the key parameter
  MainscreenAppbar({super.key})
      : preferredSize = Size.fromHeight(60.h); // Setting the height for the app bar

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CircularEdgesClipper(),
      child: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar background transparent
        elevation: 0, // Remove shadow
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kDarkBlue, kNewBlue], // Start and end colors of the gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo_white.PNG', 
              height: 80.h, 
              width: 80.w, 
            ),
            SizedBox(width: 10.w), 
            Text(
              'Cute Pets',
              style: TextStyle(
                color: kLight,
                fontSize: 20.sp, 
              ),
            ),
          ],
        ),
        centerTitle: true, 
      ),
    );
  }
}

// Custom clipper for creating circular bottom edges on the AppBar
class CircularEdgesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20); // Move to near the bottom left corner
    path.quadraticBezierTo(0, size.height, 20, size.height); // Bottom left corner
    path.lineTo(size.width - 20, size.height); // Bottom right corner before curve
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20); // Bottom right curve
    path.lineTo(size.width, 0); // Top right corner
    path.lineTo(0, 0); // Top left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

