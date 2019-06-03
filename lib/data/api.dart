import 'dart:convert';

import 'package:themoviedb/model/detailplaying.dart';
import 'package:themoviedb/model/playing.dart';
import 'package:http/http.dart' as http;
import 'package:themoviedb/model/review.dart';

class MovieRepository {
  final baseurl = "https://api.themoviedb.org/3/movie/";
  final apikey = "b64508afff2418ed0dcf89b770586d77";
  final lang = "en-US";

  Future<Playing> getNowPlaying(int pageNumber) async {
    var url = baseurl +
        'now_playing?api_key=' +
        apikey +
        '&language=' +
        lang +
        '&page=' +
        pageNumber.toString();
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Playing.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }

  Future<DetailMovie> getDetailPlaying(int id) async {
    var url = baseurl + id.toString() + '?api_key=' + apikey + '&language=' + lang;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return DetailMovie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }

  Future<ReviewModel> getReview(int pageNumber, int id) async {
    var url = baseurl +
        id.toString() +
        '/reviews?api_key=' +
        apikey +
        '&language=' +
        lang +
        '&page=' +
        pageNumber.toString();
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return ReviewModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Faild to load');
    }
  }
}
