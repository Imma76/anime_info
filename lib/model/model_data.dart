import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Anime {
  final animeList;
  Anime({
    this.animeList,
  });

  factory Anime.fromJson(Map<String, dynamic> data) {
    final animeList = data['results'];
    if (animeList == null) {
      return Anime(animeList: ['message']);
    } else {
      return Anime(animeList: data['results'] as List);
    }
  }
}

class Data extends StateNotifier<Anime> {
  Data(ProviderReference ref) : super(Anime(animeList: null));

  getAnimeData({required String animeName}) async {
    if (animeName.isNotEmpty) {
      var link =
          Uri.parse('https://api.jikan.moe/v3/search/anime?q=$animeName');
      var response = await http.get(link);
      var decode = jsonDecode(response.body);
      var list = Anime.fromJson(decode);
      state = list;
    } else {
      animeName = 'boruto';
      var link =
          Uri.parse('https://api.jikan.moe/v3/search/anime?q=$animeName');
      var response = await http.get(link);
      var decode = jsonDecode(response.body);
      var list = Anime.fromJson(decode);
      state = list;
    }
  }
}

class AnimeData {
  getAnimeData({required String animeName}) async {
    if (animeName.isNotEmpty) {
      var link =
          Uri.parse('https://api.jikan.moe/v3/search/anime?q=$animeName');
      var response = await http.get(link);
      var decode = jsonDecode(response.body);

      var anime = Anime.fromJson(decode);
      return anime.animeList;
    } else {
      animeName = 'boruto';
      var link =
          Uri.parse('https://api.jikan.moe/v3/search/anime?q=$animeName');
      var response = await http.get(link);
      var decode = jsonDecode(response.body);
      var anime = Anime.fromJson(decode);

      return anime.animeList;
    }
  }
}
