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
        title: Text(widget.item.fields.title),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${widget.item.fields.title}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Description: ${widget.item.fields.description}'),
              const SizedBox(height: 10),
              Text('Description: ${widget.item.fields.imgUrl}'),
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
                          decoration: InputDecoration(
                            labelText: 'Edit',
                            hintText: 'Edit current item...',
                            prefixIcon: const Icon(Icons.search),
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
                      const SizedBox(width: 10), // Add space between TextField and button
                      ElevatedButton(
                        onPressed: () async {
                          // Implement the functionality for the button press
                          // For example, confirm edit action
                          final response = await request.postJson(
                              'http://127.0.0.1:8000/catalogue/edit-book/',
                              convert.jsonEncode(<String, String>{
                                'idBook': widget.item.pk.toString(),
                                'description': newDesc,
                              }));
                          if (context.mounted && response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Account has been successfully registered!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ItemPage()),
                            );
                          }
                        },
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
