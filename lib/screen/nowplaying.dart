import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:themoviedb/model/playing.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/screen/detailplaying.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Future<Playing> getNowPlaying() async {
    var url =
        'https://api.themoviedb.org/3/movie/now_playing?api_key=b64508afff2418ed0dcf89b770586d77&language=en-EN&page=1';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Playing.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }

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
          future: getNowPlaying(),
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
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      height: 300.0,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500' +
                                      s.data.results[i].posterPath),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            s.data.results[i].title,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                    s.data.results[i].voteAverage.toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                              RaisedButton.icon(
                                color: Colors.white,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DetailPlaying(
                                                id: s.data.results[i].id,
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
                  });
          },
        ));
  }
}
