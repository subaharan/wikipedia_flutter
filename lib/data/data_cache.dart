import 'package:wikipedia_flutter/models/search_relsult.dart';

class SearchCache {
  final _cache = <String, Search_relsult>{};

  Search_relsult get(String term) => _cache[term];

  void set(String term, Search_relsult result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);
}