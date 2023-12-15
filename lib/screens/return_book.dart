import 'dart:collection';

import 'package:sibook_mobile/models/loan.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sibook_mobile/models/product.dart';
import 'dart:convert';
import 'package:sibook_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';



class BorrowedItemPage extends StatefulWidget {
  const BorrowedItemPage({Key? key}) : super(key: key);
  

  @override
  // ignore: library_private_types_in_public_api
  _BorrowedItemPageState createState() => _BorrowedItemPageState();
}

class _BorrowedItemPageState extends State<BorrowedItemPage> {
  // Define a TextEditingController for handling user input in the search bar
  Map<int,Product> userBorrowed=HashMap(); // List all borrowed items
  final _formKey = GlobalKey<FormState>();

  Future<Product> fetchBook(int id) async {
    var url = Uri.parse('http://127.0.0.1:8000/borrow/get-book-data/${id}');
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

  Future<Map<int,Product>> fetchBorrowed() async {
    CookieRequest request = Provider.of<CookieRequest>(context, listen: false);

    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!

    var response = await request.get('http://127.0.0.1:8000/returnBook/get-books-borrowed/');

    // melakukan konversi data json menjadi object Item
    Map<int,Product> allBorrowed = {};

    if (response != null) {
      for (var d in response) {
        if (d != null) {
          int bookId = Loan.fromJson(d).fields.book;
          Product buku = await fetchBook(bookId);
          allBorrowed.addAll({bookId:buku});
        }
      }
    }
    return allBorrowed;
  }

  //PopUp MODAL for Return Review
  Future<void> _dialogBuilder(BuildContext context,int inpBookId, String bookTitle) {
    print("Meow=> "+inpBookId.toString()+" ");
    final request = Provider.of<CookieRequest>(context, listen: false);
    final TextEditingController _reviewDescription = TextEditingController();;
    String bT = bookTitle ?? "";
    int _userID;
    int _bookID=inpBookId;


    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("""Return $bT ?"""),
          content: Form(
            key: _formKey,
            child:SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: TextFormField(
                      controller: _reviewDescription,
                      decoration: InputDecoration(
                        hintText: "Write what you think about this book",
                        labelText: "Review (Optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        return null;
                      },
                    ),
                  ),
                  ]
            ) 
          ,),),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed:  () async {Navigator.of(context).pop();}),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Return Book'),
              onPressed:  () async {
                
                if (_formKey.currentState!.validate()) {
                  print("Meow2=> "+_reviewDescription.text);
                  // Kirim ke Django dan tunggu respons
                  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!

                  if(_reviewDescription.text.isNotEmpty){
                  final response = await request.postJson(
                  "http://127.0.0.1:8000/returnBook/create-review-flutter/$_bookID/",
                  jsonEncode(<String, String>{
                      'book': _bookID.toString(),
                      'review': _reviewDescription.text,
                  }));
                        if (response['status'] == 'success') {
                            _reviewDescription.dispose();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                            content: Text("Buku Berhasil dibalikan dan review and telah diterima"),
                            ));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => BorrowedItemPage()),
                            );
                          }else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                content:
                                    Text("Terdapat kesalahan review, silakan coba lagi."),
                            ));
                        }
                        _reviewDescription.dispose();

                  }else{
                    final response = await request.postJson(
                      "http://127.0.0.1:8000/returnBook/just-return-book/$_bookID/",
                      jsonEncode(<String, String>{
                      'book': _bookID.toString()}
                      //Continue
                      ));
                    if (response['message'] == 'Book returned successfully.') {
                      _reviewDescription.dispose();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                      content: Text("Buku berhasil dibalikan"),
                      ));
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => BorrowedItemPage()),
                      );
                    }else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          content:
                              Text("Terdapat kesalahan balikan buku, silakan coba lagi."),
                      ));
                  }
                  _reviewDescription.dispose();
                  }
                }

                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(3, 2, 46, 1),
        appBar: AppBar(
          title: const Text('Borrowed Books'),
        ),
        drawer: const LeftDrawer(title: 'return_review'),
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

                    userBorrowed = snapshot.data;

                    return ListView.builder(
                      itemCount: userBorrowed.length,
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
                                "${userBorrowed.values.elementAt(index).fields.title}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 160, 234),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Id: ${userBorrowed.keys.elementAt(index)}",
                              style: const TextStyle(
                                  color : Colors.white,
                                ),),
                              const SizedBox(height: 10),
                              Text("Penulis: ${userBorrowed.values.elementAt(index).fields.author}",
                              style: const TextStyle(
                                  color : Colors.white,
                                ),),
                              const SizedBox(height: 10),
                              Text(
                                  "Banyak Halaman: ${userBorrowed.values.elementAt(index).fields.numPages}",
                                  style: const TextStyle(
                                  color : Colors.white,
                                ),),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),

                                    child: ElevatedButton(

                                      style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(const Color(0xFF6C5B7B)),
                                      ),
                                      
                                      onPressed: () => _dialogBuilder(context,userBorrowed.keys.elementAt(index),userBorrowed.values.elementAt(index).fields.title),

                                      child: const Text(
                                      "Return Book",
                                      style: TextStyle(color: Colors.white),
                                      ),
                                    ),
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
