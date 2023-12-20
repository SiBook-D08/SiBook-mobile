// To parse this JSON data, do
//
//     final favorite = favoriteFromJson(jsonString);

import 'dart:convert';

List<Favorite> favoriteFromJson(String str) =>
    List<Favorite>.from(json.decode(str).map((x) => Favorite.fromJson(x)));

String favoriteToJson(List<Favorite> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorite {
  String model;
  int pk;
  Fields fields;

  Favorite({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
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
  String alasan;

  Fields({
    required this.user,
    required this.book,
    required this.alasan,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
        alasan: json["alasan"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
        "alasan": alasan,
      };
}

// just a change to push
