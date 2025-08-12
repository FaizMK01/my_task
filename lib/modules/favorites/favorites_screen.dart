import 'package:cached_network_image/cached_network_image.dart';
import 'package:evencir_task/constants/app_colors.dart';
import 'package:evencir_task/modules/favorites/favorites_controller.dart';
import 'package:evencir_task/modules/products/product_details_screen.dart';
import 'package:evencir_task/widgets/custom_appbar';
import 'package:evencir_task/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesScreen extends StatelessWidget {
  final controller = Get.put(FavoritesController());

  FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomAppBar(title: "Favorites"),
      body: Column(
        children: [


           CustomSearchBar(
            
            hintText: 'Search Products...',onChanged: controller.updateSearchQuery,
),
          // Results Count
          Obx(() => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${controller.filteredFavorites.length} results found",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          )),
          
          SizedBox(height: 16.h),
          
          // Favorites List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerList();
              }
              
              final filteredFavorites = controller.filteredFavorites;
              
              if (filteredFavorites.isEmpty) {
                return _buildEmptyWidget();
              }
              
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: filteredFavorites.length,
                itemBuilder: (context, index) {
                  final product = filteredFavorites[index];
                  return _buildFavoriteCard(product, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(dynamic product, FavoritesController controller) {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
     //     border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(8.r),
                
              ),
              child: ClipRRect(
                
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.image_not_supported,
                    color: Colors.grey.shade400,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? 'Unknown Product',
                    style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "\$${product.price ?? 0}",
                    style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        "${product.rating ?? 0}",
                        style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
                      ),
                      SizedBox(width: 4.w),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (product.rating ?? 0).floor()
                                ? Icons.star
                                : index < (product.rating ?? 0)
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: AppColors.yellowColor,
                            size: 12.sp,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Heart Icon
            GestureDetector(
              onTap: () => controller.removeFromFavorites(product),
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            "No favorites yet",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Add products to favorites to see them here",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}