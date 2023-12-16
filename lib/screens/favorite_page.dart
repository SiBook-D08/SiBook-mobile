import 'package:sibook_mobile/models/product.dart';
import 'package:sibook_mobile/models/favorite.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sibook_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _formKey = GlobalKey<FormState>();
  String _alasan = "";

  TextEditingController searchController = TextEditingController();
  List<Product> nonFavoritedBooks = [];
  List<Product> filteredItems = [];
  Map<Product, Favorite> favoritedBooks = {};

  Future<List<Product>> fetchNonFavorited() async {
    var url = Uri.parse('http://127.0.0.1:8000/favorite/get-books/');
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

  Future<Map<Product, Favorite>> fetchFavorited() async {
    CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    var response = await request
        .get('http://127.0.0.1:8000/favorite/get-favorited-flutter/');

    Map<Product, Favorite> allFavorited = {};
    if (response != null) {
      for (var d in response) {
        if (d != null) {
          int bookId = Favorite.fromJson(d).fields.book;
          Product bookData = await fetchBookById(bookId);
          Favorite tmpFavorite = Favorite.fromJson(d);
          allFavorited.addAll({bookData: tmpFavorite});
        }
      }
    }

    return allFavorited;
  }

  Future<Product> fetchBookById(int id) async {
    var url = Uri.parse('http://localhost:8000/favorite/get-book-data/$id');
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorit'),
        ),
        drawer: const LeftDrawer(title: 'Favorit'),
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
                    filteredItems = nonFavoritedBooks.where((element) {
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
                future: fetchFavorited(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  favoritedBooks = snapshot.data;

                  return Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Buku yang telah kamu favoritkan",
                              style: const TextStyle(
                                fontSize:
                                    20.0, // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: favoritedBooks.length,
                                itemBuilder: (_, index) => InkWell(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favoritedBooks.keys
                                              .elementAt(index)
                                              .fields
                                              .title,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          favoritedBooks.values
                                              .elementAt(index)
                                              .fields
                                              .alasan,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final response = await request.postJson(
                                                'http://localhost:8000/favorite/remove-from-favorited-flutter/${favoritedBooks.values.elementAt(index).pk}/',
                                                jsonEncode(<String, String>{
                                                  'bookId': favoritedBooks.keys
                                                      .elementAt(index)
                                                      .pk
                                                      .toString(),
                                                }));

                                            if (response['status'] ==
                                                'success') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Buku berhasil dihapus dari favorit!"),
                                              ));
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FavoritePage()),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Terdapat kesalahan, silakan coba lagi."),
                                              ));
                                            }
                                          },
                                          child:
                                              const Text('Hapus dari Favorit'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: fetchNonFavorited(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    nonFavoritedBooks = snapshot.data;
                    List<Product> itemsToShow = searchController.text.isEmpty
                        ? nonFavoritedBooks
                        : filteredItems;

                    return ListView.builder(
                      itemCount: itemsToShow.length,
                      itemBuilder: (_, index) => InkWell(
                        onTap: () {},
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
                              const SizedBox(
                                  height:
                                      20), // Add more space above the button

                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: const Text(
                                              'Mengapa kamu memfavoritkan buku ini?'),
                                          content: Form(
                                              key: _formKey,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Isi alasanmu disini!",
                                                          labelText: "Alasan",
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0))),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          _alasan = value!;
                                                        });
                                                      },
                                                      validator:
                                                          (String? value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Alasan tidak boleh kosong!";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                          'Favoritkan'),
                                                      onPressed: () async {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          // Kirim ke Django dan tunggu respons
                                                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                                          final response = await request
                                                              .postJson(
                                                                  "http://127.0.0.1:8000/favorite/add-to-favorited-flutter/${itemsToShow[index].pk}/",
                                                                  jsonEncode(<String,
                                                                      String>{
                                                                    'alasan':
                                                                        _alasan,
                                                                  }));
                                                          if (response[
                                                                  'status'] ==
                                                              'success') {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  "Kamu telah berhasil memfavoritkan buku baru!"),
                                                            ));
                                                            Navigator
                                                                .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          FavoritePage()),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    const SnackBar(
                                                              content: Text(
                                                                  "Terdapat kesalahan, silakan coba lagi."),
                                                            ));
                                                          }
                                                        }
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                          'Batalkan'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                    ),
                                                  ])));
                                    },
                                  );
                                },
                                child: const Text('Favoritkan'),
                              ),
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
