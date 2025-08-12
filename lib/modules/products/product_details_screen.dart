import 'package:cached_network_image/cached_network_image.dart';
import 'package:evencir_task/modules/products/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;
  
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController(product));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: controller.toggleFavorite,
            icon: Obx(() => Icon(
              controller.isFavorite.value 
                  ? Icons.favorite 
                  : Icons.favorite_border,
              color: controller.isFavorite.value 
                  ? Colors.red 
                  : Colors.grey,
            )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            _buildImageCarousel(controller),
            
            // Product Details Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Price
                  _buildNameAndPrice(),
                  SizedBox(height: 12.h),
                  
                  // Rating and Stock
                  _buildRatingAndStock(),
                  SizedBox(height: 16.h),
                  
                  // Brand and Category
                  _buildBrandAndCategory(),
                  SizedBox(height: 16.h),
                  
                  // Description
                  _buildDescription(),
                ],
              ),
            ),
            
            SizedBox(height: 8.h),
            
            // Product Specifications
            _buildSpecifications(),
            
            SizedBox(height: 8.h),
            
            // Reviews Section
            _buildReviewsSection(),
            
            SizedBox(height: 8.h),
            
            // Shipping and Return Policy
            _buildShippingAndReturn(),
            
            SizedBox(height: 100.h), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(controller),
    );
  }

  Widget _buildImageCarousel(ProductDetailController controller) {
    return Container(
      height: 300.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.updateCurrentImageIndex,
            itemCount: product.images?.length ?? 1,
            itemBuilder: (context, index) {
              final imageUrl = product.images != null && product.images.isNotEmpty
                  ? product.images[index]
                  : product.thumbnail;
              
              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 60.sp,
                    color: Colors.grey.shade400,
                  ),
                ),
              );
            },
          ),
          
          // Image Indicators
          if (product.images != null && product.images.length > 1)
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  product.images.length,
                  (index) => Obx(() => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.currentImageIndex.value == index
                          ? Colors.blue
                          : Colors.white.withOpacity(0.5),
                    ),
                  )),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNameAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "SKU: ${product.sku}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\$${product.price}",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade600,
              ),
            ),
            if (product.discountPercentage > 0)
              Text(
                "${product.discountPercentage.toStringAsFixed(1)}% OFF",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingAndStock() {
    return Row(
      children: [
        // Rating
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < product.rating.floor()
                    ? Icons.star
                    : index < product.rating
                        ? Icons.star_half
                        : Icons.star_border,
                color: Colors.orange,
                size: 18.sp,
              );
            }),
            SizedBox(width: 8.w),
            Text(
              "${product.rating}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              "(${product.reviews?.length ?? 0} reviews)",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        
        Spacer(),
        
        // Stock
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: product.stock > 0 ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            product.stock > 0 ? "${product.stock} In Stock" : "Out of Stock",
            style: TextStyle(
              fontSize: 12.sp,
              color: product.stock > 0 ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandAndCategory() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard("Brand", product.brand),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildInfoCard("Category", product.category.replaceAll('-', ' ').toUpperCase()),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
        SizedBox(height: 12.h),
        
        // Tags
        if (product.tags != null && product.tags.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: product.tags.map<Widget>((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "#$tag",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.blue.shade700,
                ),
              ),
            )).toList(),
          ),
      ],
    );
  }

  Widget _buildSpecifications() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Specifications",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          
          _buildSpecRow("Weight", "${product.weight} kg"),
          _buildSpecRow("Dimensions", "${product.dimensions.width} x ${product.dimensions.height} x ${product.dimensions.depth} cm"),
          _buildSpecRow("Warranty", product.warrantyInformation),
          _buildSpecRow("Availability", product.availabilityStatus),
          _buildSpecRow("Minimum Order", "${product.minimumOrderQuantity} units"),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            ": ",
            style: TextStyle(fontSize: 14.sp),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    if (product.reviews == null || product.reviews.isEmpty) {
      return Container();
    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews (${product.reviews.length})",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all reviews screen
                },
                child: Text("See All"),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Show first 2 reviews
          ...product.reviews.take(2).map<Widget>((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                review.reviewerName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 14.sp,
                )),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAndReturn() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shipping & Returns",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          
          Row(
            children: [
              Icon(Icons.local_shipping, size: 20.sp, color: Colors.blue),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  product.shippingInformation,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          Row(
            children: [
              Icon(Icons.assignment_return, size: 20.sp, color: Colors.green),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  product.returnPolicy,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductDetailController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: controller.decreaseQuantity,
                  icon: Icon(Icons.remove, size: 20.sp),
                ),
                Obx(() => Text(
                  "${controller.quantity.value}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                IconButton(
                  onPressed: controller.increaseQuantity,
                  icon: Icon(Icons.add, size: 20.sp),
                ),
              ],
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Add to Cart Button
          Expanded(
            child: ElevatedButton(
              onPressed: product.stock > 0 ? controller.addToCart : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                product.stock > 0 ? "Add to Cart" : "Out of Stock",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}