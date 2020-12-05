import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.white,
  title: Text(Strings.wikipedia,
  style: TextStyle(color: Colors.black87),),
),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: Util.px_10  * SizeConfig.heightMultiplier,),
            _SearchBar(), _SearchBody()],
        ),
      ),
    );

  }
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
      padding:  EdgeInsets.only(left:Util.px_10 * SizeConfig.heightMultiplier, right: Util.px_10 * SizeConfig.heightMultiplier),
      child: TextField(
        controller: _textController,
        autocorrect: false,
        onChanged: (text) {
          _searchBloc.add(
            TextChanged(text: text),
          );
        },

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: Util.px_5 * SizeConfig.heightMultiplier),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: GestureDetector(
            onTap: _onClearTapped,
            child: const Icon(Icons.clear),
          ),
            fillColor: Colors.lime.withAlpha(70),
          border: new OutlineInputBorder(

            borderRadius: BorderRadius.all(
               Radius.circular(Util.px_25 * SizeConfig.heightMultiplier),
            ),
          ),
          hintText: 'Enter a search term',
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
          return const CircularProgressIndicator();
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

class _SearchResults extends StatelessWidget {
  final List<Pages> items;

  const _SearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index]);
      },
    );
  }

}

class _SearchResultItem extends StatelessWidget {
  final Pages item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> description = new List();
    if(item.terms != null){
      description =item.terms.description;
    }
    return GestureDetector(
      onTap: (){
        startWebPage(item);
      },
      child: Container(
        padding: EdgeInsets.all(Util.px_10 * SizeConfig.heightMultiplier),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.thumbnail != null?Container(
              width: Util.px_50 * SizeConfig.heightMultiplier,
              height: Util.px_50 * SizeConfig.heightMultiplier,
              child: Image.network(

                  item.thumbnail.source,
                fit: BoxFit.fill,

              ),
            ):Container(
              width: Util.px_50 * SizeConfig.heightMultiplier,
              height: Util.px_50 * SizeConfig.heightMultiplier,
              color: Colors.grey,
            ),
            SizedBox(width: Util.px_5 * SizeConfig.heightMultiplier,),
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
                  for(String data in description)
                  Text("$data\n",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: Util.px_12 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}


//---------------
Future startWebPage(Pages item) async {
  await Navigator.push<dynamic>(
    mContext,
    SlideBottomRoute(
        widget: WebPage(
          url: API.baseUrl + "?curid=${item.pageid}",
        )),
  );

}