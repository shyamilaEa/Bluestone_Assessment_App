import 'package:bluestone_app/constants/colors.dart';
import 'package:bluestone_app/screens/product_detail_screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  int page = 1; 
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    setState(() {
      if (page == 1) {
        isLoading = true;
      } else {
        isFetchingMore = true;
      }
    });

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products?limit=20&page=$page'),
      );
      if (response.statusCode == 200) {
        final fetchedProducts = json.decode(response.body) as List<dynamic>;

        final uniqueProducts = fetchedProducts.toSet(); 

        setState(() {
          products.addAll(uniqueProducts.cast<Map<String, dynamic>>()); 
          isLoading = false;
          isFetchingMore = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isFetchingMore = false;
      });
      print('Error fetching products: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isFetchingMore) {
      setState(() {
        page++;
      });
      fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorClass.darkBlue,
        elevation: 4,
        centerTitle: true,
      ),
      body: isLoading && products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.61,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final rating = product['rating']?['rate'] ?? 0.0;
                        final ratingCount = product['rating']?['count'] ?? 0;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(productId: product['id']),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 6,
                            shadowColor: Colors.grey.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    product['image'],
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '\$${product['price']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: ColorClass.darkBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$rating (${ratingCount} ratings)',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (isFetchingMore)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
    );
  }
}