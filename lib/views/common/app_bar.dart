import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';
import 'app_styles.dart';
import 'reuseable_text.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.text, required this.child, this.color, this.actions});

  final String? text;
  final Widget child;
  final Color? color;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(),
      backgroundColor: color ?? Color(kLight.value),
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 70.w,
      leading: child,
      actions: actions,
      centerTitle: true,
      title: ReusableText(
        // We are checking whether we are providing color to the backgroundColor above.
        // if we are providing color, we will set our text to white. else it will be black
          text: text??"", style: appStyle(16, color!=null ? Color(kLight.value): Color(kDark.value), FontWeight.w600)),
    );
  }
}
