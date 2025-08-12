import 'package:cached_network_image/cached_network_image.dart';
import 'package:evencir_task/constants/app_colors.dart';
import 'package:evencir_task/modules/products/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;
  
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController(product));

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Padding(
          padding:  EdgeInsets.only(left: 20.w),
          child: Text(
            "Product Details",
            style: GoogleFonts.playfairDisplay(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
              
          ),),
        ),
        leading:GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset('assets/icons/arrowback.png'),
            ))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              _buildProductImage(controller),
              
              SizedBox(height: 20.h),
              
              // Product Details Section
              _buildProductDetails(controller),
              
              SizedBox(height: 20.h),
              
              // Product Gallery
              _buildProductGallery(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductDetailController controller) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: CachedNetworkImage(
          imageUrl: product.thumbnail ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 40.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Image not available",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(ProductDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Heart Icon
        Row(
          children: [
            Text(
              "Product Details:",
              style: GoogleFonts.poppins(
            fontSize: 18.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
            ),
            Spacer(),
            GestureDetector(
              onTap: controller.toggleFavorite,
              child: GetBuilder<ProductDetailController>(
                builder: (_) => Icon(
                  controller.isFavorite 
                      ? Icons.favorite 
                      : Icons.favorite_border,
                  color: controller.isFavorite 
                      ? AppColors.redColor
                      : AppColors.blackColor,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Product Details
        _buildDetailRow("Name:", product.title ?? 'N/A'),
        SizedBox(height: 8.h),
        
        _buildDetailRow("Price:", "\$${product.price ?? 0}"),
        SizedBox(height: 8.h),
        
        _buildDetailRow("Category:", _formatCategory(product.category ?? 'N/A')),
        SizedBox(height: 8.h),
        
        _buildDetailRow("Brand:", product.brand ?? 'N/A'),
        SizedBox(height: 8.h),
        
        _buildRatingRow(),
        SizedBox(height: 8.h),
        
        _buildDetailRow("Stock:", "${product.stock ?? 0}"),
        SizedBox(height: 16.h),
        
        // Description
        Text(
          "Description:",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          product.description ?? 'No description available',
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
            
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
          Text(
            label,
            style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
          ),
          SizedBox(width: 12.w),
        
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
            
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "Rating:",
            style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
          ),
     
        SizedBox(width: 12.w),
        Text(
          "${product.rating ?? 0}",
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w400,
            
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
              size: 10.sp,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProductGallery() {
    // Get all images including thumbnail
    List<String> allImages = [];
    if (product.images != null) {
      allImages.addAll(List<String>.from(product.images));
    }
    if (product.thumbnail != null && !allImages.contains(product.thumbnail)) {
      allImages.insert(0, product.thumbnail);
    }

    if (allImages.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Product Gallery:",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1,
          ),
          itemCount: allImages.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: allImages[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 30.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatCategory(String category) {
    return category.replaceAll('-', ' ').split(' ')
        .map((word) => word.capitalize)
        .join(' ');
  }
}