class Product {
  final String name;
  final double price;
  final String urlIamge;

  Product({required this.name, required this.price, required this.urlIamge});
}

List<Product> products = [
  Product(
      name: 'Minimal Stand 1',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 2',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 3',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 4',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 5',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 6',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 7',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 8',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 9',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 10',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 11',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 12',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 13',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 14',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 15',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 16',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 17',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 18',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 19',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
  Product(
      name: 'Minimal Stand 20',
      price: 2000000.0,
      urlIamge: 'assets/images/img_product.png'),
];

Future<List<Product>> getProduct() async {
  await Future.delayed(const Duration(seconds: 2));
  return products;
}
