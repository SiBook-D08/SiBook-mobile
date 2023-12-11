import 'package:sibook_mobile/screens/borrow.dart';
import 'package:sibook_mobile/screens/favorite_page.dart';
import 'package:sibook_mobile/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:sibook_mobile/screens/item_list_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sibook_mobile/screens/add_item_form.dart';

class ShopItem {
  final String name;
  final IconData icon;
  final Color color;
  ShopItem(this.name, this.icon, this.color);
}

class ShopCard extends StatelessWidget {
  final ShopItem item;

  const ShopCard(this.item, {super.key}); // Constructor

	@override
	Widget build(BuildContext context) {
		final request = context.watch<CookieRequest>();
		return Material(
      color: item.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () async {
        // Memunculkan SnackBar ketika diklik
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text("Kamu telah menekan tombol ${item.name}!")));
        if (item.name == "Tambah Item") {
          Navigator.push(context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'donate'),
              builder: (context) => const AddItemForm(),
            ));
        } else if (item.name == "Lihat Item") {
          Navigator.push(context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'catalogue'),
              builder: (context) => const ItemPage(),
            ));
        }else if (item.name == "Borrow"){
          Navigator.push(context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'borrow'),
              builder: (context) => const BorrowPage(),
            ));
        } else if (item.name == "Favorit") {
            Navigator.push(context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'favorite'),
                builder: (context) => const FavoritePage(),
              ));
        } else if (item.name == "Logout") {
          final response = await request.logout(
            // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
            "http://127.0.0.1:8000/auth/logout/");
          String message = response["message"];

          if (!context.mounted) {
            return;
          }

          if (response['status']) {
            String uname = response["username"];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("$message Sampai jumpa, $uname."),
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
            ));
          }
        }
        },
        child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              item.icon,
              color: Colors.white,
              size: 100.0,
            ),
            Text(
              item.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      )

      ),
		);
	}
}
