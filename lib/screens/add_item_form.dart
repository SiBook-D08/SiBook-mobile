import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sibook_mobile/screens/menu.dart';
import 'package:sibook_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddItemForm extends StatefulWidget {
  const AddItemForm({super.key});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
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
        backgroundColor: const Color.fromARGB(255, 142, 168, 125),
        foregroundColor: Colors.white,
      ),

      // tempat drawer
      drawer: const LeftDrawer(title: 'donate'),

      //nampilin body page
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 0, 11, 0),
            Color.fromARGB(255, 78, 117, 151),
            Color.fromARGB(249, 238, 203, 156),
            ],
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      controller: _titleCtrl,
                      style: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                      decoration: InputDecoration(
                          // hintStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                          // hintText: "Judul Buku",
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
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      controller: _authorCtrl,
                      style: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                      decoration: InputDecoration(
                        // hintStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                        // hintText: "Author Buku",
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
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      controller: _pageCountCtrl,
                      style: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                      decoration: InputDecoration(
                        // hintStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                        // hintText: "Jumlah Halaman",
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
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 10.0,
                    ),
                    child: TextFormField(
                      controller: _descCtrl,
                      style: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                      decoration: InputDecoration(
                        // hintStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 243, 231, 231)),
                        // hintText: "Deskripsi",
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
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
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
                                }));
                                
                            if (!context.mounted) {
                              return;
                            }

                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text("Item baru berhasil disimpan!")));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage()));
                            } else if (response['status'] == 'full') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text("Maaf, katalog buku sudah penuh.")));
                            } else if (response['status'] == 'alrExists') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content:
                                          Text("Buku dengan judul yang sama sudah ada di katalog!")));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text("Terdapat kesalahan, silakan coba lagi.")));
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
        ),
      ),
    );
  }
}
