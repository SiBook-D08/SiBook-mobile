import 'package:sibook_mobile/models/product.dart';
import 'package:sibook_mobile/models/cart.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sibook_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  // Define a TextEditingController for handling user input in the search bar
  TextEditingController searchController = TextEditingController();
  List<Product> allItems = []; // List to hold all items
  List<Product> filteredItems = [];
  List<Product> allCart = []; // List to hold filtered items
  Future<List<Product>> fetchItem() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
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

  Future<Product> fetchBookById(int id) async {
    var url = Uri.parse('http://localhost:8000/borrow/get-book-data/$id');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      return Product.fromJson(
          data[0]); // Assuming Book is the model representing your data
    } else {
      throw Exception(
          'Failed to load book. Status code: ${response.statusCode}');
    }
  }

  Future<List<Product>> fetchCart() async {
    CookieRequest request = Provider.of<CookieRequest>(context, listen: false);

    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!

    var response = await request.get('http://127.0.0.1:8000/borrow/get-cart/');

    // melakukan konversi data json menjadi object Item
    List<Product> listCart = [];

    if (response != null) {
      for (var d in response) {
        if (d != null) {
          int idBuku = Cart.fromJson(d).fields.book;
          print(idBuku);
          Product buku = await fetchBookById(idBuku);
          print(buku);
          listCart.add(buku);
          print("::::" + buku.toString());
        }
      }
    }
    return listCart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Borrow'),
        ),
        drawer: const LeftDrawer(title: 'borrow'),
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
                future: fetchCart(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  allCart = snapshot.data;
                  print(snapshot.data);
                  List<Product> itemsToShow = allCart;
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: itemsToShow.length,
                          itemBuilder: (_, index) => InkWell(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemsToShow[index].fields.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final request =
                                          Provider.of<CookieRequest>(context,
                                              listen: false);
                                      final response = await request.post(
                                          'http://localhost:8000/borrow/remove-cart-flutter/${itemsToShow[index].pk}/',
                                          {});

                                      if (!context.mounted) {
                                        return;
                                      }

                                      if (response['status'] == 'success') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Produk baru berhasil disimpan!"),
                                        ));
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BorrowPage()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Terdapat kesalahan, silakan coba lagi."),
                                        ));
                                      }
                                    },
                                    child: const Text('Keluarkan'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final request = Provider.of<CookieRequest>(context,
                              listen: false);
                          final response = await request.post(
                              'http://localhost:8000/borrow/add-to-list-flutter/',
                              {'username': request.jsonData['username']});

                          if (!context.mounted) {
                            return;
                          }

                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Produk baru berhasil disimpan!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BorrowPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Terdapat kesalahan, silakan coba lagi."),
                            ));
                          }
                        },
                        child: const Text('Pinjam'),
                      ),
                    ],
                  );
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
                  List<Product> itemsToShow =
                      searchController.text.isEmpty ? allItems : filteredItems;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: itemsToShow.length,
                    itemBuilder: (_, index) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 150.0, // Set a minimum width for the card
                            maxHeight: 10.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
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
                                Text(
                                  itemsToShow[index].fields.description.length >
                                          200
                                      ? "${itemsToShow[index].fields.description.substring(0, 201)}..."
                                      : itemsToShow[index].fields.description,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Banyak Halaman: ${itemsToShow[index].fields.numPages}",
                                ),
                                const SizedBox(height: 5),
                                ElevatedButton(
                                  onPressed: () async {
                                    
                                    final request = Provider.of<CookieRequest>(
                                        context,
                                        listen: false);
                                        print("-> " + request.jsonData.toString());
                                    final response = await request.post(
                                        'http://localhost:8000/borrow/add-to-cart-flutter/${itemsToShow[index].pk}/',
                                        {
                                          'username': request.jsonData['username']
                                        });

                                    if (!context.mounted) {
                                      return;
                                    }
                                    
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Produk baru berhasil disimpan!"),
                                      ));
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const BorrowPage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Terdapat kesalahan, silakan coba lagi."),
                                      ));
                                    }
                                  },
                                  child: const Text('Masukkan Keranjang'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
