import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:themoviedb/model/detailplaying.dart';
import 'package:themoviedb/screen/expadeditem.dart';

class DetailPlaying extends StatefulWidget {
  final int id;
  DetailPlaying({Key key, @required this.id}) : super(key: key);

  @override
  _DetailPlayingState createState() => _DetailPlayingState();
}

class _DetailPlayingState extends State<DetailPlaying> {
  final f = DateFormat('yyyy-MM-dd');

  Future<DetailMovie> getDetailPlaying() async {
    var url =
        'https://api.themoviedb.org/3/movie/${widget.id}?api_key=b64508afff2418ed0dcf89b770586d77&language=en-EN&page=1';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return DetailMovie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDetailPlaying(),
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
                        IconButton(
                          icon: Icon(Icons.favorite),
                          onPressed: () {},
                        )
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
