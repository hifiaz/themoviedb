import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:themoviedb/model/review.dart';
import 'package:http/http.dart' as http;

class Review extends StatefulWidget {
  final int id;
  Review({Key key, this.id}) : super(key: key);
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  Future<ReviewModel> getReview() async {
    var url =
        'https://api.themoviedb.org/3/movie/${widget.id}/reviews?api_key=b64508afff2418ed0dcf89b770586d77&language=en-US&page=1';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ReviewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('All Review'),
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: getReview(),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return ListView.builder(
                  itemCount: s.data.results.length,
                  itemBuilder: (BuildContext c, int i) {
                    return Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(),
                                  SizedBox(width: 8.0),
                                  Text(
                                    s.data.results[i].author,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(s.data.results[i].content),
                              Divider()
                            ]));
                  });
          }),
    );
  }
}
