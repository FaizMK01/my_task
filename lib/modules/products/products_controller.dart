import 'package:evencir_task/data/models/products_model.dart';
import 'package:evencir_task/data/services/api_services.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var searchQuery = ''.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch products from API using ApiService
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      errorMessage('');
      
      final productListResponse = await ApiService.fetchProducts();
      products.value = productListResponse.products;
      filteredProducts.value = productListResponse.products;
    } catch (e) {
      errorMessage('Error loading products: ${e.toString()}');
      print('Error fetching products: $e');
    } finally {
      isLoading(false);
    }
  }

  // Search functionality
  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.brand.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  // Get product image with fallback
  String getProductImage(Product product) {
    if (product.images.isNotEmpty) {
      return product.images.first;
    } else if (product.thumbnail.isNotEmpty) {
      return product.thumbnail;
    }
    return '';
  }

  // Format price
  String formatPrice(double price) {
    return '\$${price.toStringAsFixed(0)}';
  }

  // Get rating stars
  String getRatingStars(double rating) {
    int fullStars = rating.floor();
    String stars = '★' * fullStars;
    if (rating - fullStars >= 0.5) {
      stars += '☆';
    }
    while (stars.length < 5) {
      stars += '☆';
    }
    return stars;
  }
}