import 'package:evencir_task/modules/categories/categories_screen.dart';
import 'package:evencir_task/modules/favorites/favorites_screen.dart';
import 'package:evencir_task/modules/products/products_screen.dart';
import 'package:evencir_task/modules/user/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<Widget> pages = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: Container(
  height: 75.h,
  width: 360.w,
  decoration: BoxDecoration(
    color: Colors.black, 
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(5.r),
      topLeft: Radius.circular(5.r),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5.r,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(5.r),
      topLeft: Radius.circular(5.r),
    ),
    child: BottomNavigationBar(
      
      backgroundColor: Colors.black,
      currentIndex: controller.selectedIndex.value,
      onTap: controller.changeTab,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 10.sp,
        height: 1.0,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 10.sp,
        height: 1.0,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/Products.png', width: 21.w, height: 21.h),
              SizedBox(height: 4.h),
            ],
          ),
          label: "Products",
        ),
        BottomNavigationBarItem(
          
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/categories.png', width: 21.w, height: 21.h),
              SizedBox(height: 4.h),
            ],
          ),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/favorites.png', width: 21.w, height: 21.h),
              SizedBox(height: 4.h),
            ],
          ),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/setting.png', width: 21.w, height: 21.h),
              SizedBox(height: 4.h),
            ],
          ),
          label: "Mitt konto",
        ),
      ],
    ),
  ),
)

      ),
    );
  }
}
