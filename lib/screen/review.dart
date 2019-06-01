import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:themoviedb/data/api.dart';
import 'package:themoviedb/model/review.dart';

class Review extends StatefulWidget {
  final int id;
  Review({Key key, this.id}) : super(key: key);
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('All Review'),
        centerTitle: false,
      ),
      body: FutureBuilder(
          future: MovieRepository().getReview(1, widget.id),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return new ReviewList(
                reviews: s.data,
              );
          }),
    );
  }
}

class ReviewList extends StatefulWidget {
  final ReviewModel reviews;
  ReviewList({
    this.reviews,
    Key key,
  }) : super(key: key);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final ScrollController scrollController = ScrollController();
  List<Result> review;
  int currentPage = 1;

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        MovieRepository()
            .getReview(currentPage + 1, widget.reviews.id)
            .then((val) {
          currentPage = val.page;
          setState(() {
            review.addAll(val.results);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    review = widget.reviews.results;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: onNotification,
      child: ListView.builder(
          itemCount: review.length,
          controller: scrollController,
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
                            review[i].author,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(review[i].content),
                      Divider()
                    ]));
          }),
    );
  }
}
