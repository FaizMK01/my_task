import 'dart:convert';
import 'package:evencir_task/data/models/products_model.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class ApiService {

  static const String baseUrl = "https://dummyjson.com/products/categories";

//fetching all products
static Future<ProductListResponse> fetchProducts() async {
  try {
    // Replace with your actual API endpoint
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final productListResponse = ProductListResponse.fromJson(jsonData);
      return productListResponse;
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error loading products: ${e.toString()}');
  }
}

//fetching all category
static Future<List<CategoryModel>> fetchCategoriesFast() async {
  // Step 1: Get all categories
  final catRes = await http.get(Uri.parse("https://dummyjson.com/products/categories"));
  if (catRes.statusCode != 200) throw Exception("Failed to load categories");

  List categories = jsonDecode(catRes.body);

  // Step 2: Fetch one product for each category in parallel
  List<Future<CategoryModel>> futures = categories.map<Future<CategoryModel>>((cat) async {
    String slug = cat is Map ? cat['slug'] ?? cat['name'] ?? cat.toString() : cat.toString();

    try {
      final prodRes = await http.get(Uri.parse("https://dummyjson.com/products/category/$slug?limit=1"));
      if (prodRes.statusCode == 200) {
        final prodData = jsonDecode(prodRes.body);
        String image = '';
        if (prodData['products'] != null && prodData['products'].isNotEmpty) {
          image = prodData['products'][0]['thumbnail'] ?? '';
        }
        return CategoryModel(
          slug: slug,
          name: slug[0].toUpperCase() + slug.substring(1),
          image: image,
        );
      }
    } catch (_) {}

    // fallback if no product or image found
    return CategoryModel(
      slug: slug,
      name: slug[0].toUpperCase() + slug.substring(1),
      image: '',
    );
  }).toList();

  // Step 3: Wait for all results
  return await Future.wait(futures);
}

//fetching products by category
static Future<List<Product>> getProductsByCategory(String slug) async {
  final response = await http.get(
    Uri.parse("https://dummyjson.com/products/category/$slug"),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List products = data['products'];
    return products.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load products");
  }
}

}