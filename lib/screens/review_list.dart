import 'package:sibook_mobile/models/product.dart';
import 'package:sibook_mobile/models/review.dart';
import 'package:sibook_mobile/screens/oneitem.dart';
import 'package:sibook_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sibook_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  //Store reviews
  Map<Product, Review> userReviews = {};

  Future<Product> fetchBook(int id) async {
    var url = Uri.parse(
        'https://sibook-d08-tk.pbp.cs.ui.ac.id/borrow/get-book-data/${id}');
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

  Future<String> fetchUser(int idx) async {
    var url = Uri.parse(
        'https://sibook-d08-tk.pbp.cs.ui.ac.id/returnBook/get-user-data/${idx}');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      List<String> temp = data[0].toString().split(",");
      return temp[5].replaceAll("username: ", "");
    } else {
      throw Exception(
          'Failed to load book. Status code: ${response.statusCode}');
    }
  }

  Future<Map<Product, Review>> fetchBorrowed() async {
    CookieRequest request = Provider.of<CookieRequest>(context, listen: false);

    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!

    var response = await request.get(
        'https://sibook-d08-tk.pbp.cs.ui.ac.id/returnBook/user-reviews/get-reviews-experimental/');

    // melakukan konversi data json menjadi object Item
    Map<Product, Review> allReviews = {};

    if (response != null) {
      for (var d in response) {
        if (d != null) {
          int bookId = Review.fromJson(d).fields.book;
          Product buku = await fetchBook(bookId);
          Review tempReview = Review.fromJson(d);
          allReviews.addAll({buku: tempReview});
        }
      }
    }
    return allReviews;
  }

  FutureBuilder<String> buildUsernameFuture(int userIdx) {
    return FutureBuilder<String>(
      future: fetchUser(userIdx),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading username...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Text(
            '✾ From: ${snapshot.data}',
            style: const TextStyle(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(3, 2, 46, 1),
        appBar: AppBar(
          title: const Text('User Reviews'),
        ),
        drawer: const LeftDrawer(title: 'all_review'),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: fetchBorrowed(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    userReviews = snapshot.data;

                    return ListView.builder(
                      itemCount: userReviews.length,
                      itemBuilder: (_, index) => Container(
                        child: Container(
                          color: Color.fromARGB(255, 2, 57, 101),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userReviews.keys.elementAt(index).fields.title,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 160, 234),
                                ),
                              ),
                              buildUsernameFuture(userReviews.values
                                  .elementAt(index)
                                  .fields
                                  .user),
                              const SizedBox(height: 10),
                              Text(
                                userReviews.values
                                    .elementAt(index)
                                    .fields
                                    .review,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
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
