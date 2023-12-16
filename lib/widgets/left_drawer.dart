import 'package:flutter/material.dart';
import 'package:sibook_mobile/screens/add_item_form.dart';
import 'package:sibook_mobile/screens/borrow.dart';
import 'package:sibook_mobile/screens/favorite_page.dart';
import 'package:sibook_mobile/screens/item_list_page.dart';
import 'package:sibook_mobile/screens/menu.dart';
import 'package:sibook_mobile/screens/return_book.dart';
import 'package:sibook_mobile/screens/review_list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key, required this.title});

  final String title;

  double _getIconSize(Size screenSize) {
    final double iconSize;

    if (screenSize.width < 600) {
      iconSize = 20.0;
    } else {
      iconSize = 25.0;
    }

    return iconSize;
  }

  double _getFontSize(Size screenSize) {
    final double fontSize;

    if (screenSize.width < 600) {
      fontSize = 16.0;
    } else {
      fontSize = 18.0;
    }

    return fontSize;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double fontSize = _getFontSize(screenSize);
    final double iconSize = _getIconSize(screenSize);

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
            leading: Icon(
              Icons.home_outlined,
              size: iconSize,
            ),
            title: Text(
              'Homepage',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

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
            leading: Icon(
              Icons.add_shopping_cart,
              size: iconSize,
            ),
            title: Text(
              'Tambah Item',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

            // ketika diklik akan ke page add_item
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
            leading: Icon(
              Icons.shopping_bag_outlined,
              size: iconSize,
            ),
            title: Text(
              'Lihat Item',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

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
            leading: Icon(
              Icons.shopping_bag_outlined,
              size: iconSize,
            ),
            title: Text(
              'Pinjam Buku',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

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
          ListTile(
            leading: Icon(
              Icons.auto_stories,
              size: iconSize,
            ),
            title: Text(
              'Kembalikan Buku',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

            // ketika diklik akan ke page pengembalian buku
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'return_review') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'return_review'),
                    builder: (context) => const BorrowedItemPage(),
                  ),
                  (route) => route.settings.name == 'home',
                );
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark,
              size: iconSize,
            ),
            title: Text(
              'Favoritkan Buku',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

            // ketika diklik akan ke page favorite
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'favorite') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'favorite'),
                    builder: (context) => const FavoritePage(),
                  ),
                  (route) => route.settings.name == 'home',
                );
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.archive_rounded,
              size: iconSize,
            ),
            title: Text(
              'Reviews',
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),

            // ketika diklik akan ke page review list
            onTap: () async {
              await Navigator.maybePop(context);
              if (context.mounted && title != 'all_review') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'all_review'),
                    builder: (context) => const ReviewPage(),
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
