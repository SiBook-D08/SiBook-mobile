// To parse this JSON data, do
//
//     final loan = loanFromJson(jsonString);

import 'dart:convert';

List<Loan> loanFromJson(String str) => List<Loan>.from(json.decode(str).map((x) => Loan.fromJson(x)));

String loanToJson(List<Loan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Loan {
    String model;
    int pk;
    Fields fields;

    Loan({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Loan.fromJson(Map<String, dynamic> json) => Loan(
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
