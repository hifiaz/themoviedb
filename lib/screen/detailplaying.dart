import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/data/api.dart';
import 'package:themoviedb/data/dbhelper.dart';
import 'package:themoviedb/model/favorite.dart';
import 'package:themoviedb/screen/expadeditem.dart';

class DetailPlaying extends StatefulWidget {
  final int id;
  DetailPlaying({Key key, @required this.id}) : super(key: key);

  @override
  _DetailPlayingState createState() => _DetailPlayingState();
}

class _DetailPlayingState extends State<DetailPlaying> {
  final f = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MovieRepository().getDetailPlaying(widget.id),
        builder: (BuildContext c, AsyncSnapshot s) {
          if (s.data == null) {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else
            return Stack(
              children: <Widget>[
                Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500' +
                                  s.data.posterPath),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter),
                    )),
                Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      iconTheme: IconThemeData(color: Colors.white),
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      actions: <Widget>[
                        new FavoriteButton(
                          id: s.data.id,
                          title: s.data.originalTitle,
                          poster: s.data.posterPath,
                          overview: s.data.overview,
                          vote: s.data.voteAverage,
                        ),
                      ],
                    ),
                    body: Container(
                      color: Colors.transparent,
                    )),
                ExhibitionBottomSheet(
                    id: s.data.id,
                    title: s.data.originalTitle,
                    image: s.data.backdropPath,
                    overview: s.data.overview,
                    releasedate: f.format(s.data.releaseDate),
                    runtime: s.data.runtime,
                    vote: s.data.voteAverage,
                    genres: s.data.genres)
              ],
            );
        });
  }
}

class FavoriteButton extends StatefulWidget {
  final int id;
  final double vote;
  final String title, poster, overview;
  const FavoriteButton({
    this.id,
    this.title,
    this.poster,
    this.overview,
    this.vote,
    Key key,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBprovider.db.getFavorite(widget.id),
        builder: (BuildContext c, AsyncSnapshot s) {
          if (s.hasData)
            return IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                DBprovider.db.deleteFavorite(widget.id);
                setState(() {});
              },
            );
          else
            return IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                final mov = Favorite(
                  title: widget.title,
                  id: widget.id,
                  poster: widget.poster,
                  overview: widget.overview,
                  vote: widget.vote,
                  // genres: s.data.genres
                );
                DBprovider.db.newFavorite(mov);
                setState(() {});
              },
            );

          //  else {
          //   return Text('Load');
          // }
          // if (s.data != null) {
          //   return IconButton(
          //     icon: Icon(Icons.favorite),
          //     onPressed: () {
          //       final mov = Favorite(
          //         title: title,
          //         id: id,
          //         poster: poster,
          //         overview: overview,
          //         vote: vote,
          //         // genres: s.data.genres
          //       );
          //       DBprovider.db.newFavorite(mov);
          //     },
          //   );
          // } else {
          //   IconButton(
          //     icon: Icon(
          //       Icons.favorite,
          //       color: Colors.red,
          //     ),
          //     onPressed: () {
          //       DBprovider.db.deleteFavorite(id);
          //     },
          //   );
          // }
        });
  }
}

const double minHeight = 120;

class ExhibitionBottomSheet extends StatefulWidget {
  final String title, image, overview, releasedate;
  final int runtime, id;
  final List genres;
  final double vote;
  ExhibitionBottomSheet({
    Key key,
    @required this.title,
    @required this.image,
    @required this.overview,
    this.runtime,
    this.genres,
    this.id,
    this.vote,
    this.releasedate,
  }) : super(key: key);
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState();
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height;
  double get headerTopMargin =>
      lerp(40, 20 + MediaQuery.of(context).padding.top);
  double get headerFontSize => lerp(18, 20);
  double get itemBorderRadius => lerp(8, 24);
  double get iconLeftBorderRadius => itemBorderRadius;
  double get iconRightBorderRadius => lerp(8, 0);
  double get iconSize => lerp(44, 120);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Positioned(
            height: lerp(minHeight, maxHeight),
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _toggle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Scaffold(
                  body: Stack(
                    children: <Widget>[
                      SheetHeader(
                        title: widget.title,
                        fontSize: headerFontSize,
                        topMargin: headerTopMargin,
                      ),
                      MenuButton(),
                      // _buildFullItem()
                      ExpandedEventItem(
                          topMargin: MediaQuery.of(context).size.height / 8,
                          leftMargin: MediaQuery.of(context).size.width / 100,
                          height: MediaQuery.of(context).size.height,
                          isVisible:
                              _controller.status == AnimationStatus.completed,
                          borderRadius: itemBorderRadius,
                          image: widget.image,
                          overview: widget.overview,
                          releasedate: widget.releasedate,
                          runtime: widget.runtime,
                          vote: widget.vote,
                          id: widget.id,
                          genres: widget.genres)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 24,
      child: Icon(
        Icons.menu,
        size: 28,
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {Key key,
      @required this.fontSize,
      @required this.topMargin,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text(
        (title == null) ? 'loading..' : title,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        softWrap: true,
      ),
    );
  }
}
