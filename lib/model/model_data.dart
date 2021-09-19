import 'dart:convert';

import 'package:http/http.dart' as http;

class Data {
  getAnimeData({required String animeName}) async {
    if (animeName.isNotEmpty) {
      var link =
          Uri.parse('https://api.jikan.moe/v3/search/anime?q=$animeName');
      var response = await http.get(link);
      var decode = jsonDecode(response.body);

      final anime = Anime.fromJson(decode);
      print(anime.animeList);
      // final list = anime.animeList as List<Anime>;
      //print(anime.animeList);
      return anime.animeList;
    } else {
      animeName = 'boruto';
      var link =
          Uri.parse('https://api.jikan.moe/v3/search/anime?q=$animeName');
      var response = await http.get(link);
      var decode = jsonDecode(response.body);
      final anime = Anime.fromJson(decode);
      //final list = anime.animeList as List<Anime>;
      //print(anime.animeList);
      return anime.animeList;
    }
  }
}

class Anime {
  final animeList;

  Anime({
    required this.animeList,
  });
  factory Anime.fromJson(Map<String, dynamic> data) {
    final animeList = data['results'];
    if (animeList == null) {
      // throw UnimplementedError('No data');
      return Anime(animeList: ['message']);
    } else {
      return Anime(animeList: data['results'] as List);
    }
  }
}
