import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenHeaderText extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const ScreenHeaderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,  // agar back button nahi chahiye to
      centerTitle: true,
      toolbarHeight: 80.h,
      title: Padding(
        padding: EdgeInsets.only(top: 16.h),  // appBar already has some padding, adjust as needed
        child: Text(
          text,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w600,
            fontSize: 24.sp,
            height: 1.0,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
