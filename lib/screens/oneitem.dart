import 'package:flutter/material.dart';
import 'package:sibook_mobile/models/product.dart';
import 'package:sibook_mobile/screens/item_list_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

class ItemDetailPage extends StatefulWidget {
  final Product item;
  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  // ignore: prefer_const_constructors
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  TextEditingController descController = TextEditingController();
  String newDesc = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.fields.title,
          style: const TextStyle(
            color: Colors.black, // Change text color to black
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), // Change icon color to black
      ),
      backgroundColor: const Color.fromRGBO(3, 2, 46, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${widget.item.fields.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, 
                    color: Color.fromARGB(255, 255, 160, 234),),    
              ),
              const SizedBox(height: 10),
              Text('Description: ${widget.item.fields.description}',
                  style: const TextStyle(color: Colors.white)),
              // Displaying the image using Image.network
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: double.infinity, // You can set a specific width here
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: descController,
                          style: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                          decoration: InputDecoration(
                            labelText: 'Edit',
                            hintText: 'Edit current book...',
                            prefixIcon: const Icon(Icons.edit),
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            // Perform actions on value change if needed
                            setState(() {
                              newDesc = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Add space between TextField and button
                      ElevatedButton(
                        onPressed: () async {
                          // Implement the functionality for the button press
                          // For example, confirm edit action
                          final response = await request.postJson(
                            'https://sibook-d08-tk.pbp.cs.ui.ac.id/catalogue/edit-book/',
                            convert.jsonEncode(<String, String>{
                              'idBook': widget.item.pk.toString(),
                              'description': newDesc,
                            }),
                          );
                          if (context.mounted && response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Deskripsi Berhasil Diedit!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ItemPage(),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF6C5B7B)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
