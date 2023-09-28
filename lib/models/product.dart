class Product {
  final String name;
  final double price;
  final String urlIamge;

  Product({required this.name, required this.price, required this.urlIamge});
}

List<Product> products = [
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
];

Future<List<Product>> getProduct() async {
  await Future.delayed(const Duration(seconds: 2));
  return products;
}
