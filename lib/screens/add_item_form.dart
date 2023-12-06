import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sibook_mobile/screens/item_list_page.dart';
import 'package:sibook_mobile/screens/menu.dart';
import 'package:sibook_mobile/widgets/left_drawer.dart';
import 'package:sibook_mobile/models/product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemState();
}

class _AddItemState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _authorCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _pageCountCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _authorCtrl.dispose();
    _descCtrl.dispose();
    _pageCountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "TAMBAH BUKU",
          ),
        ),
        backgroundColor: const Color.fromARGB(221, 67, 182, 54),
        foregroundColor: Colors.white,
      ),

      // tempat drawer
      drawer: const LeftDrawer(title: 'donate'),

      //nampilin body page
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                      hintText: "Judul Buku",
                      labelText: "Judul Buku",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Judul buku tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _authorCtrl,
                  decoration: InputDecoration(
                    hintText: "Author Buku",
                    labelText: "Author Buku",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Penulis buku tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _pageCountCtrl,
                  decoration: InputDecoration(
                    hintText: "Jumlah Halaman",
                    labelText: "Jumlah Halaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Jumlah halaman tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Jumlah halaman harus berupa integer!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descCtrl,
                  decoration: InputDecoration(
                    hintText: "Deskripsi",
                    labelText: "Deskripsi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black87),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Kirim ke Django dan tunggu respons
                        final response = await request.postJson(
                            "http://127.0.0.1:8000/donate/create-flutter/",
                            jsonEncode(<String, String>{
                              'title': _titleCtrl.text,
                              'author': _authorCtrl.text,
                              'description': _descCtrl.text,
                              'num_pages': _pageCountCtrl.text,
                              'avaliable': 'true',
                            }));
                            
                        if (!context.mounted) {
                          return;
                        }

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                content: Text("Item baru berhasil disimpan!"),
                              ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                              ));
                        }
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
