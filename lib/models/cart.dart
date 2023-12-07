// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Cart> productFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String productToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
    String model;
    int pk;
    Fields fields;

    Cart({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    int book;

    Fields({
        required this.user,
        required this.book,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
    };
}
