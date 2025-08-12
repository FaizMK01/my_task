import 'package:evencir_task/constants/app_colors.dart';
import 'package:evencir_task/widgets/custom_appbar';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(title: "Mitt konto"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Profile Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Profile Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Faiz Muhammad Khan',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Color(0xffF2F2F2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'faizmk340@gmail.com',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Color(0xffF2F2F2),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+923185441753',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Color(0xffF2F2F2),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Items
            Column(
              children: [
                _buildMenuItem(icon: "setting1", title: "Kontoinstallningar"),
                SizedBox(height: 15.h),
                _buildMenuItem(icon: "setting2", title: "Mina betalmetoder"),
                 SizedBox(height: 15.h),
                _buildMenuItem(icon: "setting3", title: "Support"),

              ],
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildMenuItem({required String icon, required String title}) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w,top: 20.h),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/$icon.png',
            height: 22.h, 
            width: 22.w, 
            fit: BoxFit.contain,
          ),
          SizedBox(width: 17.w),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
