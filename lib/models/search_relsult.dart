import 'pages_model.dart';


class Search_relsult {
  Continue _continue;
  Query _query;

  Continue get continueData => _continue;
  Query get query => _query;

  Search_relsult({
      Continue continueData,
      Query query}){
    _continue = continueData;
    _query = query;
}

  Search_relsult.fromJson(dynamic json) {
    _continue = json["continue"] != null ? Continue.fromJson(json["continue"]) : null;
    _query = json["query"] != null ? Query.fromJson(json["query"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_continue != null) {
      map["continue"] = _continue.toJson();
    }
    if (_query != null) {
      map["query"] = _query.toJson();
    }
    return map;
  }

}

/// redirects : [{"index":4,"from":"Sachin The Film","to":"Sachin: A Billion Dreams"}]
/// pages : [{"pageid":57570,"ns":0,"title":"Sachin Tendulkar","index":1,"terms":{"description":["Indian former cricketer"]}},{"pageid":6957873,"ns":0,"title":"Sachin Pilot","index":7,"terms":{"description":["Indian politician"]}},{"pageid":10730502,"ns":0,"title":"Sachin (actor)","index":6,"thumbnail":{"source":"https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/SachinPilgaonkar.jpg/33px-SachinPilgaonkar.jpg","width":33,"height":50},"terms":{"description":["Indian actor, director, producer, Writer, singer"]}},{"pageid":16941961,"ns":0,"title":"Sachin Shroff","index":10,"terms":{"description":["Indian actor"]}},{"pageid":20817418,"ns":0,"title":"Sachin Khedekar","index":9,"terms":{"description":["Indian actor"]}},{"pageid":42182160,"ns":0,"title":"Sachin Bansal","index":8,"terms":{"description":["Indian Entrepreneur, founder and CEO of Flipkart.com"]}},{"pageid":42382589,"ns":0,"title":"Sachin! Tendulkar Alla","index":3,"terms":{"description":["2014 film by Mohan Shankar"]}},{"pageid":50125865,"ns":0,"title":"Sachin: A Billion Dreams","index":4,"terms":{"description":["2017 Indian biographical film directed by James Erskine"]}},{"pageid":53197293,"ns":0,"title":"Sachintha Peiris","index":5,"terms":{"description":["cricketer"]}},{"pageid":61165764,"ns":0,"title":"Sachin Tanwar","index":2}]

class Query {
  List<Redirects> _redirects;
  List<Pages> _pages;

  List<Redirects> get redirects => _redirects;
  List<Pages> get pages => _pages;

  Query({
      List<Redirects> redirects, 
      List<Pages> pages}){
    _redirects = redirects;
    _pages = pages;
}

  Query.fromJson(dynamic json) {
    if (json["redirects"] != null) {
      _redirects = [];
      json["redirects"].forEach((v) {
        _redirects.add(Redirects.fromJson(v));
      });
    }
    if (json["pages"] != null) {
      _pages = [];
      json["pages"].forEach((v) {
        _pages.add(Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_redirects != null) {
      map["redirects"] = _redirects.map((v) => v.toJson()).toList();
    }
    if (_pages != null) {
      map["pages"] = _pages.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// pageid : 57570
/// ns : 0
/// title : "Sachin Tendulkar"
/// index : 1
/// terms : {"description":["Indian former cricketer"]}



/// description : ["Indian former cricketer"]



/// index : 4
/// from : "Sachin The Film"
/// to : "Sachin: A Billion Dreams"

class Redirects {
  int _index;
  String _from;
  String _to;

  int get index => _index;
  String get from => _from;
  String get to => _to;

  Redirects({
      int index, 
      String from, 
      String to}){
    _index = index;
    _from = from;
    _to = to;
}

  Redirects.fromJson(dynamic json) {
    _index = json["index"];
    _from = json["from"];
    _to = json["to"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["index"] = _index;
    map["from"] = _from;
    map["to"] = _to;
    return map;
  }

}

/// picontinue : 42182160
/// continue : "||pageterms"

class Continue {
  int _picontinue;
  String _continue;

  int get picontinue => _picontinue;
  String get continueData => _continue;

  Continue({
      int picontinue, 
      String continueData}){
    _picontinue = picontinue;
    _continue = continueData;
}

  Continue.fromJson(dynamic json) {
    _picontinue = json["picontinue"];
    _continue = json["continue"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["picontinue"] = _picontinue;
    map["continue"] = _continue;
    return map;
  }

}