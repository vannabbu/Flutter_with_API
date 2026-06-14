import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_connect_aoi/Screen/products/product_detail_screen.dart';
import 'package:flutter_connect_aoi/models/product/ProductReponse.dart';
import 'package:flutter_connect_aoi/models/product/Products.dart';
import 'package:http/http.dart' as httpclient;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Products> allProducts = [];
  List<Products> displayedProducts = [];

  bool isLoading = false;
  bool isLoadingMore = false;

  final int pageSize = 5;

  final TextEditingController searchController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  @override
  void initState() {
    super.initState();

    _getAllProduct();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _getAllProduct() async {
    setState(() {
      isLoading = true;
    });

    try {
      var uri = Uri.parse("https://dummyjson.com/products");

      var response = await httpclient.get(uri);

      if (response.statusCode == 200) {
        var mapResponse = jsonDecode(response.body);

        var productResponse =
        ProductReponse.fromJson(mapResponse);

        setState(() {
          allProducts = productResponse.products ?? [];

          displayedProducts =
              allProducts.take(pageSize).toList();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadMore() async {
    if (isLoadingMore) return;

    if (searchController.text.isNotEmpty) return;

    if (displayedProducts.length >= allProducts.length) {
      return;
    }

    setState(() {
      isLoadingMore = true;
    });

    await Future.delayed(
      const Duration(seconds: 5),
    );

    int totalItems =
        displayedProducts.length + pageSize;

    if (totalItems > allProducts.length) {
      totalItems = allProducts.length;
    }

    setState(() {
      displayedProducts =
          allProducts.take(totalItems).toList();

      isLoadingMore = false;
    });
  }

  void searchProduct(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        displayedProducts =
            allProducts.take(pageSize).toList();
      });
      return;
    }

    setState(() {
      displayedProducts = allProducts.where((product) {
        return product.title
            ?.toLowerCase()
            .contains(keyword.toLowerCase()) ??
            false;
      }).toList();
    });
  }

  Widget buildProductCard(Products product) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.network(
              product.thumbnail ?? "",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return const SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              product.title ?? "No Title",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10),
            child: Text(
              "Price : \$${product.price}",
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Discount : ${product.discountPercentage ?? 0}%",
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            child: Text(
              product.description ?? "",
              maxLines: 3,
              overflow:
              TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text(
          "Products",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(
          color: Colors.cyan,
        ),
      )
          : Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(10),
            child: TextField(
              controller:
              searchController,
              onChanged:
              searchProduct,
              decoration:
              InputDecoration(
                hintText:
                "Search Product...",
                prefixIcon:
                const Icon(
                  Icons.search,
                ),
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                      15),
                ),
              ),
            ),
          ),
          Expanded(
            child:
            RefreshIndicator(
              onRefresh:
              _getAllProduct,
              child:
              ListView.builder(
                controller:
                _scrollController,
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 16,
                ),
                itemCount:
                displayedProducts
                    .length +
                    1,
                itemBuilder:
                    (context,
                    index) {
                  if (index ==
                      displayedProducts
                          .length) {
                    return isLoadingMore
                        ? const Padding(
                      padding:
                      EdgeInsets
                          .all(
                          20),
                      child:
                      Center(
                        child:
                        CircularProgressIndicator(),
                      ),
                    )
                        : const SizedBox();
                  }

                  var product =
                  displayedProducts[
                  index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: product,
                          ),
                        ),
                      );
                    },
                    child: buildProductCard(product),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}