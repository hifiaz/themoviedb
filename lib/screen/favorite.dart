import 'package:flutter/material.dart';
import 'package:themoviedb/data/dbhelper.dart';
import 'package:themoviedb/screen/detailplaying.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Movie"),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: DBprovider.db.getAllFavorite(),
        builder: (BuildContext c, AsyncSnapshot s) {
          if (s.hasData) {
            return ListView.builder(
              itemCount: s.data.length,
              itemBuilder: (BuildContext c, int i) {
                return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Image.network(
                          'https://image.tmdb.org/t/p/w500' + s.data[i].poster,
                          height: 200.0,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  s.data[i].title,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(s.data[i].vote.toString()),
                                Text(s.data[i].overview),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        DBprovider.db
                                            .deleteFavorite(s.data[i].id);
                                        setState(() {});
                                      },
                                    ),
                                    FlatButton(
                                      color: Colors.orange,
                                      child: Text('Details'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        DetailPlaying(
                                                          id: s.data[i].id,
                                                        )));
                                      },
                                    )
                                  ],
                                )
                              ]),
                        ),
                        Divider()
                      ],
                    ));
              },
            );
          } else if (s.hasError) {
            return Center(
              child: Text('No Data'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
