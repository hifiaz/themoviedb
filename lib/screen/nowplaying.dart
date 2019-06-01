import 'package:flutter/material.dart';
import 'package:themoviedb/data/api.dart';
import 'package:themoviedb/model/playing.dart';
import 'package:themoviedb/screen/detailplaying.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'NOW PLAYING',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          centerTitle: false,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: FutureBuilder(
          future: MovieRepository().getNowPlaying(1),
          builder: (BuildContext c, AsyncSnapshot s) {
            if (s.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return ItemMovie(
                playing: s.data,
              );
          },
        ));
  }
}

class ItemMovie extends StatefulWidget {
  final Playing playing;
  const ItemMovie({
    this.playing,
    Key key,
  }) : super(key: key);

  @override
  _ItemMovieState createState() => _ItemMovieState();
}

class _ItemMovieState extends State<ItemMovie> {
  final ScrollController scrollController = new ScrollController();
  int firstpage = 1;
  List<Result> movies;

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              50) {
        MovieRepository().getNowPlaying(firstpage + 1).then((play) {
          firstpage = play.page;
          setState(() {
            movies.addAll(play.results);
          });
        });
      }
    }
    return true;
  }

  @override
  void initState() {
    movies = widget.playing.results;
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
            itemCount: movies.length,
            controller: scrollController,
            itemBuilder: (BuildContext c, int i) {
              return ListMovie(
                movie: movies[i],
              );
            }));
  }
}

class ListMovie extends StatelessWidget {
  final Result movie;
  const ListMovie({
    this.movie,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      height: 300.0,
      decoration: BoxDecoration(
          color: Colors.orange,
          image: DecorationImage(
              image: (movie.posterPath == null)
                  ? AssetImage('images/bg.png')
                  : NetworkImage(
                      'https://image.tmdb.org/t/p/w500' + movie.posterPath),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter),
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            movie.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25.0),
          ),
          Expanded(
            child: Container(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(movie.voteAverage.toString(),
                    style: TextStyle(color: Colors.white)),
              ),
              RaisedButton.icon(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DetailPlaying(
                                id: movie.id,
                              )));
                },
                label: Text('See Details'),
                icon: Icon(Icons.keyboard_arrow_right),
              )
            ],
          )
        ],
      ),
    );
  }
}
