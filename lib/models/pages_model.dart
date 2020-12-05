class Pages {
  int _pageid;
  int _ns;
  String _title;
  int _index;
  Terms _terms;
  Thumbnail _thumbnail;

  int get pageid => _pageid;
  int get ns => _ns;
  String get title => _title;
  int get index => _index;
  Terms get terms => _terms;
  Thumbnail get thumbnail => _thumbnail;

  Pages({
    int pageid,
    int ns,
    String title,
    int index,
    Terms terms,
    Thumbnail thumbnail}){
    _pageid = pageid;
    _ns = ns;
    _title = title;
    _index = index;
    _terms = terms;
    _thumbnail = thumbnail;
  }

  Pages.fromJson(dynamic json) {
    _pageid = json["pageid"];
    _ns = json["ns"];
    _title = json["title"];
    _index = json["index"];
    _terms = json["terms"] != null ? Terms.fromJson(json["terms"]) : null;
    _thumbnail = json["thumbnail"] != null ? Thumbnail.fromJson(json["thumbnail"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["pageid"] = _pageid;
    map["ns"] = _ns;
    map["title"] = _title;
    map["index"] = _index;
    if (_terms != null) {
      map["terms"] = _terms.toJson();
    }
    if (_thumbnail != null) {
      map["thumbnail"] = _thumbnail.toJson();
    }
    return map;
  }

}

class Terms {
  List<String> _description;

  List<String> get description => _description;

  Terms({
    List<String> description}){
    _description = description;
  }

  Terms.fromJson(dynamic json) {
    _description = json["description"] != null ? json["description"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["description"] = _description;
    return map;
  }

}


class Thumbnail {
  String _source;
  int _width;
  int _height;

  String get source => _source;
  int get width => _width;
  int get height => _height;

  Thumbnail({
    String source,
    int width,
    int height}){
    _source = source;
    _width = width;
    _height = height;
  }

  Thumbnail.fromJson(dynamic json) {
    _source = json["source"];
    _width = json["width"];
    _height = json["height"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["source"] = _source;
    map["width"] = _width;
    map["height"] = _height;
    return map;
  }

}