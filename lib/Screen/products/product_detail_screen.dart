import 'package:flutter/material.dart';
import 'package:flutter_connect_aoi/models/product/Products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Products product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title ?? 'Product Detail'),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Image.network(
              product.thumbnail ?? "",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding:
              const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style:
                    const TextStyle(
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Card(
                    elevation: 3,
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                          15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color:
                                Colors.green,
                              ),
                              const SizedBox(
                                  width: 10),
                              Text(
                                "Price : \$${product.price}",
                                style:
                                const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 10),

                          Row(
                            children: [
                              const Icon(
                                Icons.discount,
                                color:
                                Colors.orange,
                              ),
                              const SizedBox(
                                  width: 10),
                              Text(
                                "Discount : ${product.discountPercentage ?? 0}%",
                                style:
                                const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    product.description ?? '',
                    style:
                    const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    width:
                    double.infinity,
                    height: 50,
                    child:
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Added To Cart",
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                      ),
                      label: const Text(
                        "Add To Cart",
                      ),
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        Colors.cyan,
                        foregroundColor:
                        Colors.white,
                      ),
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
}