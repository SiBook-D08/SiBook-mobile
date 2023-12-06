// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    Model model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String author;
    String description;
    int numPages;
    String imgUrl;
    bool avaliable;
    bool favorited;
    int lastEditedUser;

    Fields({
        required this.title,
        required this.author,
        required this.description,
        required this.numPages,
        required this.imgUrl,
        required this.avaliable,
        required this.favorited,
        required this.lastEditedUser,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        author: json["author"],
        description: json["description"],
        numPages: json["num_pages"],
        imgUrl: json["img_url"],
        avaliable: json["avaliable"],
        favorited: json["favorited"],
        lastEditedUser: json["last_edited_user"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
        "num_pages": numPages,
        "img_url": imgUrl,
        "avaliable": avaliable,
        "favorited": favorited,
        "last_edited_user": lastEditedUser,
    };
}

enum Model {
    CATALOGUE_BOOK
}

final modelValues = EnumValues({
    "catalogue.book": Model.CATALOGUE_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}