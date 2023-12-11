import 'package:flutter/material.dart';
import 'package:sibook_mobile/screens/add_item_form.dart';
import 'package:sibook_mobile/screens/borrow.dart';
import 'package:sibook_mobile/screens/item_list_page.dart';
import 'package:sibook_mobile/screens/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              children: [
                Text(
                  "SiBook",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Tambahkan Buku disini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Homepage'),

            //Ketika diklik akan ke homepage
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'home') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'home'),
                    builder: (context) => MyHomePage(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text("Tambah Item"),

            // ketika diklik akan ke forms add_item
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'donate') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'donate'),
                    builder: (context) => const AddItemForm(),
                  ),
                  (route) => route.settings.name == 'home',
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("Lihat Item"),

            // ketika diklik akan ke list item
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'catalogue') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'catalogue'),
                    builder: (context) => const ItemPage(),
                  ),
                  (route) => route.settings.name == 'home',
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("Pinjam Buku"),

            // ketika diklik akan ke page peminjaman buku
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'borrow') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'borrow'),
                    builder: (context) => const BorrowPage(),
                  ),
                  (route) => route.settings.name == 'home',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
