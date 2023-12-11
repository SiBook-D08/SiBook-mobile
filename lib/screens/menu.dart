import 'package:flutter/material.dart';
import 'package:sibook_mobile/widgets/item_card.dart';
import 'package:sibook_mobile/widgets/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

	final List<ShopItem> items = [
		ShopItem("Lihat Item",  Icons.checklist, const Color(0xFF1A46BD)),
		ShopItem("Tambah Item", Icons.add_shopping_cart, const Color(0xFF0F286B)),
		ShopItem("Logout", Icons.logout, const Color(0xFF091840)),
    ShopItem("Borrow", Icons.book, const Color.fromARGB(255, 29, 52, 115)),
    ShopItem("Favorit", Icons.bookmark, const Color.fromARGB(255, 8, 67, 232)),
	];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'SiBook',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(221, 67, 182, 54),
        foregroundColor: const Color.fromARGB(255, 125, 113, 113),
      ),
      drawer: const LeftDrawer(title: 'home'),
      body: SingleChildScrollView(
        // Widget wrapper yang dapat discroll
        child: Padding(
          padding: const EdgeInsets.all(10.0), // Set padding dari halaman
          child: Column(
            // Widget untuk menampilkan children secara vertikal
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                // Widget Text untuk menampilkan tulisan dengan alignment center dan style yang sesuai
                child: Text(
                  'Selamat datang di SiBook', // Text yang menandakan toko
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Grid layout
              GridView.count(
                // Container pada card kita.
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: items.map((ShopItem item) {
                  // Iterasi untuk setiap item
                  return ShopCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
		);
	}
}
