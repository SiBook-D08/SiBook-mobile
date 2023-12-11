import 'package:sibook_mobile/models/product.dart';
import 'package:sibook_mobile/screens/oneitem.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sibook_mobile/widgets/left_drawer.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  // Define a TextEditingController for handling user input in the search bar
  TextEditingController searchController = TextEditingController();
  List<Product> allItems = []; // List to hold all items
  List<Product> filteredItems = []; // List to hold filtered items
  Future<List<Product>> fetchItem() async {
    var url = Uri.parse('http://127.0.0.1:8000/catalogue/get-books/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // melakukan konversi data json menjadi object Item
    List<Product> listItem = [];
    for (var d in data) {
      if (d != null) {
        listItem.add(Product.fromJson(d));
      }
    }
    return listItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Item'),
        ),
        drawer: const LeftDrawer(title: 'catalogue'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'Search for items...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filteredItems = allItems.where((element) {
                      return element.fields.title
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: fetchItem(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    allItems = snapshot.data;
                    List<Product> itemsToShow = searchController.text.isEmpty
                        ? allItems
                        : filteredItems;

                    return ListView.builder(
                      itemCount: itemsToShow.length,
                      itemBuilder: (_, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailPage(
                                item: itemsToShow[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                itemsToShow[index].fields.title,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(itemsToShow[index].fields.author),
                              const SizedBox(height: 10),
                              Text(itemsToShow[index]
                                          .fields
                                          .description
                                          .length >
                                      200
                                  ? "${itemsToShow[index].fields.description.substring(0, 201)}..."
                                  : itemsToShow[index].fields.description),
                              const SizedBox(height: 10),
                              Text(
                                  "Banyak Halaman: ${itemsToShow[index].fields.numPages}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
