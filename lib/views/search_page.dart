import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_pickers/language_pickers.dart';
import 'package:language_pickers/languages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:wikipedia_flutter/animation/slide_route.dart';
import 'package:wikipedia_flutter/bloc/search_bloc.dart';
import 'package:wikipedia_flutter/bloc/search_event.dart';
import 'package:wikipedia_flutter/bloc/search_state.dart';
import 'package:wikipedia_flutter/common/size_config.dart';
import 'package:wikipedia_flutter/common/strings.dart';
import 'package:wikipedia_flutter/data/api.dart';
import 'package:wikipedia_flutter/models/pages_model.dart';
import 'package:wikipedia_flutter/utils/utils.dart';
import 'package:wikipedia_flutter/views/web_display.dart';

BuildContext mContext;
Language _selectedDialogLanguage = LanguagePickerUtils.getLanguageByIsoCode('en');
ScrollController _controller;

class SearchPage extends StatefulWidget {

  @override
  _SearchStatePage createState() => _SearchStatePage();
}

class _SearchStatePage extends State<SearchPage> {

  Future<void> readPreferenceValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString("language") != null) {
      setState(() {
        _selectedDialogLanguage = LanguagePickerUtils.getLanguageByIsoCode(pref.getString("language"));
      });

      print("language ${_selectedDialogLanguage.name}");
    }else{
      pref.setString("language", 'en');
      // _selectedDialogLanguage = LanguagePickerUtils.getLanguageByIsoCode('en');
    }
  }
  @override
  void initState() {
    readPreferenceValue();
    // TODO: implement initState
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

  }
  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          Strings.wikipedia,
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          GestureDetector(
            onTap: _openLanguagePickerDialog,
            child: Row(
              children: [
                Icon(Icons.language, color: Colors.black87,),
                Text(
                  _selectedDialogLanguage.name,
                  style: TextStyle(color: Colors.black87,
                  fontSize: Util.px_11 * SizeConfig.textMultiplier),
                ),
                SizedBox(width: Util.px_10 * SizeConfig.heightMultiplier,)
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: Util.px_10 * SizeConfig.heightMultiplier,
            ),
            _SearchBar(),
            _SearchBody()
          ],
        ),
      ),
    );
  }


  Widget _buildDialogItem(Language language) => Row(
    children: <Widget>[
      Text(language.name),
      SizedBox(width: 8.0),
      Flexible(child: Text("(${language.isoCode})"))
    ],
  );

  void _openLanguagePickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: LanguagePickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: Strings.search),
            isSearchable: true,
            title: Text(Strings.select_your_language),
            onValuePicked: (Language language) async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setString("language", language.isoCode);
              setState((){
                _selectedDialogLanguage = language;

              });
        } ,
            itemBuilder: _buildDialogItem)),
  );
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Util.px_10 * SizeConfig.heightMultiplier,
          right: Util.px_10 * SizeConfig.heightMultiplier),
      child: Container(
        height: Util.px_50 * SizeConfig.heightMultiplier,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                autocorrect: false,

                onChanged: (text) {
                  /*_searchBloc.add(
                    TextChanged(text: text),
                  );*/
                },

                decoration: InputDecoration(

                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  // contentPadding: EdgeInsets.only(left: Util.px_5 * SizeConfig.heightMultiplier, top: 0),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:GestureDetector(
                    onTap: _onClearTapped,
                    child: const Icon(Icons.clear),
                  ),

                  fillColor: Colors.lime.withAlpha(70),
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.only(topLeft:
                      Radius.circular(Util.px_25 * SizeConfig.heightMultiplier,),
                    bottomLeft: Radius.circular(Util.px_25 * SizeConfig.heightMultiplier,)),

                  ),
                  hintText: 'Enter a search term',
                ),

              ),

            ),
            GestureDetector(
              onTap: (){
                _searchBloc.add(
                  TextChanged(text: _textController.text),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: Util.px_48 * SizeConfig.heightMultiplier,
                padding: EdgeInsets.only(left:Util.px_5 * SizeConfig.heightMultiplier, right: Util.px_10 * SizeConfig.heightMultiplier),
                // height: double.infinity,
                decoration: _searchButtonBackground(),
                child: Text(Strings.search_,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: Util.px_13 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    _searchBloc.add(const TextChanged(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchStateLoading) {
          return _loading();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? const Text('No Results')
              : Expanded(child: _SearchResults(items: state.items));
        }
        return const Text('');
      },
    );
  }
}

Widget _loading() {
  return SkeletonLoader(
    builder: Container(
      padding: EdgeInsets.symmetric(
          horizontal: Util.px_10 * SizeConfig.heightMultiplier,
          vertical: Util.px_10 * SizeConfig.heightMultiplier),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: Util.px_30 * SizeConfig.heightMultiplier,
          ),
          SizedBox(width: Util.px_10 * SizeConfig.heightMultiplier),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: Util.px_10 * SizeConfig.heightMultiplier,
                  color: Colors.white,
                ),
                SizedBox(height: Util.px_10 * SizeConfig.heightMultiplier),
                Container(
                  width: double.infinity,
                  height: Util.px_12 * SizeConfig.heightMultiplier,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    items: 3,
    period: Duration(seconds: 2),
    highlightColor: Colors.lightBlue[300],
    direction: SkeletonDirection.ltr,
  );
}

class _SearchResults extends StatelessWidget {
  final List<Pages> items;

  const _SearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index]);
      },
    );
  }
}

_scrollListener() {

  if (_controller.offset >= _controller.position.maxScrollExtent &&
      !_controller.position.outOfRange) {
 /*   setState(() {
      print("reach the bottom");
      _onScrollCheck("Test");
    });*/
  }
  if (_controller.offset <= _controller.position.minScrollExtent &&
      !_controller.position.outOfRange) {
    /*setState(() {
      print("reach the top");
    });*/
  }
}

class _SearchResultItem extends StatelessWidget {
  final Pages item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> description = new List();
    if (item.terms != null) {
      description = item.terms.description;
    }
    return GestureDetector(
      onTap: () {
        startWebPage(item);
      },
      child: Container(
        padding: EdgeInsets.all(Util.px_10 * SizeConfig.heightMultiplier),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.thumbnail != null
                ? Container(
                    width: Util.px_50 * SizeConfig.heightMultiplier,
                    height: Util.px_50 * SizeConfig.heightMultiplier,
                    child: Image.network(
                      item.thumbnail.source,
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(
                    width: Util.px_50 * SizeConfig.heightMultiplier,
                    height: Util.px_50 * SizeConfig.heightMultiplier,
                    color: Colors.grey,
                  ),
            SizedBox(
              width: Util.px_5 * SizeConfig.heightMultiplier,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Util.px_14 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.bold,
                      )),
                  for (String data in description)
                    Text("$data\n",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: Util.px_12 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------
BoxDecoration _searchButtonBackground() {
  // Add box decoration
  return BoxDecoration(
    // Box decoration takes a gradient
    borderRadius: BorderRadius.only(
        topRight: Radius.circular(Util.px_25 * SizeConfig.heightMultiplier), bottomRight: Radius.circular(Util.px_25 * SizeConfig.heightMultiplier)),
    border: Border.all(
      width: 1.0,
      color: Colors.blue,
    ),
    color: Colors.blue
  );
}



//---------------
Future startWebPage(Pages item) async {
  await Navigator.push<dynamic>(
    mContext,
    SlideBottomRoute(
        widget: WebPage(
          title: item.title,
      url:API.https_+_selectedDialogLanguage.isoCode+ API.baseUrl + "?curid=${item.pageid}&action=mobileview",
    )),
  );
}
