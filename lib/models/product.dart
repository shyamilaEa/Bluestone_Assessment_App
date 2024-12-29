class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final String category;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
      price: json['price'].toDouble(),
      rating: json['rating']['rate'].toDouble(),
    );
  }
}
