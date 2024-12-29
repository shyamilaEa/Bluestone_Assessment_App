import 'dart:convert';
import 'package:bluestone_app/models/product.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts(int limit) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<Product> fetchProductDetails(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
