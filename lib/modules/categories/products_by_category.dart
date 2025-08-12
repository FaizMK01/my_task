import 'package:cached_network_image/cached_network_image.dart';
import 'package:evencir_task/constants/app_colors.dart';
import 'package:evencir_task/modules/categories/products_by_category_controller.dart';
import 'package:evencir_task/modules/products/product_details_screen.dart';
import 'package:evencir_task/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProductByCategory extends StatelessWidget {
  final String slug;
  
  const ProductByCategory({Key? key, required this.slug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductByCategoryController(slug));

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset('assets/icons/arrowback.png')),
        ),
        title: Text(
          slug.split('-').map((word) => word.capitalize).join(' '),
          style: GoogleFonts.playfairDisplay(
            fontSize: 24.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [

          CustomSearchBar(
            
            hintText: 'Search Products...',onChanged: controller.updateSearchQuery,
),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildShimmerList();
              }

              if (controller.error.value.isNotEmpty) {
                return _buildErrorWidget(controller);
              }

              final filteredProducts = controller.filteredProducts;

              if (filteredProducts.isEmpty) {
                return _buildEmptyWidget();
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailScreen(product: product));
        print("Tapped on: ${product.title}");
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0), // No border radius to match design
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: double.infinity,
                  height: 200.h,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey.shade400,
                    size: 50.sp,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Product Details
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Expanded(
                        child: Text(
                          product.title,
                          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
                        ),
                      ),
                      
                      SizedBox(width: 12.w),
                      
                      // Price
                      Text(
                        "\$${product.price}",
                        style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  // Rating
                  Row(
                    children: [
                      Text(
                        "${product.rating}",
                        style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
                      ),
                      SizedBox(width: 4.w),
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.yellowColor,
                          size: 14.sp,
                        );
                      }),
                    ],
                  ),
                  
                  SizedBox(height: 4.h),
                  
                  // Brand
                  Text(
                    "By ${product.brand}",
                    style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: Colors.blueGrey.shade200,
            fontWeight: FontWeight.w400,
            
          ),
                  ),
                  
                  SizedBox(height: 2.h),
                  
                  // Category
                  Text(
                    "In ${slug.split('-').map((word) => word.toLowerCase()).join(' ')}",
                    style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
            
          ),
                  ),
                ],
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
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              
              SizedBox(height: 12.h),
              
              // Content placeholders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title placeholder
                  Container(
                    width: 200.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  
                  // Price placeholder
                  Container(
                    width: 50.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8.h),
              
              // Rating placeholder
              Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ...List.generate(5, (index) => Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: Container(
                      width: 14.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  )),
                ],
              ),
              
              SizedBox(height: 6.h),
              
              // Brand placeholder
              Container(
                width: 80.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              
              SizedBox(height: 4.h),
              
              // Category placeholder
              Container(
                width: 120.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              
              SizedBox(height: 16.h),
            ],
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
            Icons.search_off,
            size: 80.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            "No products found",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Try searching with different keywords",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(ProductByCategoryController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.sp,
            color: Colors.red.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              controller.error.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: controller.fetchProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Retry",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}