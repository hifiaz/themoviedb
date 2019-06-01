// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

class ReviewModel {
    int id;
    int page;
    List<Result> results;
    int totalPages;
    int totalResults;

    ReviewModel({
        this.id,
        this.page,
        this.results,
        this.totalPages,
        this.totalResults,
    });

    factory ReviewModel.fromRawJson(String str) => ReviewModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ReviewModel.fromJson(Map<String, dynamic> json) => new ReviewModel(
        id: json["id"],
        page: json["page"],
        results: new List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "page": page,
        "results": new List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Result {
    String author;
    String content;
    String id;
    String url;

    Result({
        this.author,
        this.content,
        this.id,
        this.url,
    });

    factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Result.fromJson(Map<String, dynamic> json) => new Result(
        author: json["author"],
        content: json["content"],
        id: json["id"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "content": content,
        "id": id,
        "url": url,
    };
}
