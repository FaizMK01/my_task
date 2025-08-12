import 'package:evencir_task/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.controller,
    this.margin,
    this.backgroundColor,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(5.r),

      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        textInputAction: textInputAction ?? TextInputAction.search,
        onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400
          ),
          prefixIcon: Padding(
  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
  child: SizedBox(
    height: 13.h, 
    width: 16.16.w,  
    child: Image.asset(
      "assets/icons/search.png",
      fit: BoxFit.contain,
    ),
  ),
),

                    enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(
              color: AppColors.blackColor,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(
              color: AppColors.blackColor,
              width: 1.5,
            ),
          ),
        
        ),
        style:  GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400
          ),
      ),
    );
  }
}
