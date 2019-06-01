import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:themoviedb/model/review.dart';
import 'package:themoviedb/screen/review.dart';
import 'package:http/http.dart' as http;

class ExpandedEventItem extends StatefulWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final double vote;
  final String image, overview, releasedate;
  final int runtime, id;
  final List genres;

  const ExpandedEventItem(
      {Key key,
      this.topMargin,
      this.id,
      this.height,
      this.isVisible,
      this.borderRadius,
      this.image,
      this.overview,
      this.releasedate,
      this.runtime,
      this.vote,
      this.genres,
      this.leftMargin})
      : super(key: key);

  @override
  _ExpandedEventItemState createState() => _ExpandedEventItemState();
}

class _ExpandedEventItemState extends State<ExpandedEventItem> {
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
    return Positioned(
      top: widget.topMargin,
      left: widget.leftMargin,
      right: 0,
      height: widget.height,
      child: AnimatedOpacity(
        opacity: widget.isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // color: Colors.blue
          ),
          padding: EdgeInsets.all(8),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500' + widget.image),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.green,
              child: Text(
                widget.vote.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.runtime.toString() + " Minutes",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.releasedate.toString(),
                  // releasedate.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 10),
        Wrap(
            children: widget.genres
                .map((genre) => Container(
                      margin: EdgeInsets.only(right: 5.0, bottom: 5.0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Text(
                        genre.name.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ))
                .toList()),
        SizedBox(height: 10),
        Text(widget.overview, style: TextStyle(fontSize: 16)),
        SizedBox(
          height: 10.0,
        ),
        Text('Top Review',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
        SizedBox(
          height: 10.0,
        ),
        FutureBuilder(
            future: getReview(),
            builder: (BuildContext c, AsyncSnapshot s) {
              if (s.data == null) {
                return Center(
                  child: Text('No Review'),
                );
              } else
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (s.data.results.length >= 3)
                        ? 3
                        : s.data.results.length,
                    itemBuilder: (BuildContext c, int i) {
                      return ExpansionTile(
                        leading: CircleAvatar(),
                        title: Text(s.data.results[i].author),
                        children: <Widget>[
                          Text(s.data.results[i].content),
                        ],
                      );
                    });
            }),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: double.infinity,
          height: 45.0,
          child: RaisedButton(
            color: Colors.orange,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Review(
                            id: widget.id,
                          )));
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            elevation: 0.0,
            child: Text('See All Review'),
          ),
        ),
        SizedBox(
          height: 150.0,
        )
      ],
    );
  }
}
