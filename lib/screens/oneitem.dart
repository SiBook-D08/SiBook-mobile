import 'package:flutter/material.dart';
import 'package:sibook_mobile/models/Item.dart'; // Assuming Item.dart contains Product class

class ItemDetailPage extends StatelessWidget {
  final Product item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.fields.title),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${item.fields.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Description: ${item.fields.description}'),
            const SizedBox(height: 10),
            Text('Description: ${item.fields.imgUrl}'),
            // Displaying the image using Image.network
            const SizedBox(height: 10),
            // Image.network(item.fields.imgUrl)
            // ignore: unnecessary_null_comparison
          ],
        ),
      ),
    );
  }
}
