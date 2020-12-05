import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:wikipedia_flutter/data/api.dart';
import 'package:wikipedia_flutter/data/data_cache.dart';
import 'package:wikipedia_flutter/models/pages_model.dart';
import 'package:wikipedia_flutter/models/search_relsult.dart';

import 'search_event.dart';
import 'search_state.dart';



class SearchBloc extends Bloc<SearchEvent, SearchState> {
   SearchCache cache;

  SearchBloc() : super(SearchStateEmpty());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events,
      Stream<Transition<SearchEvent, SearchState>> Function(
          SearchEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is TextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          // await Future<void>.delayed(Duration(seconds: 2));
         /* if (cache.contains(searchTerm)) {
            Search_relsult response = await cache.get(searchTerm);
            // Search_relsult result = new Search_relsult.fromJson(json.decode(response.body.toString()));
            List<Pages> list = response.query.pages;
            yield SearchStateSuccess(list);
          } else {*/
            var response = await API.search(searchTerm);
            Search_relsult result = new Search_relsult.fromJson(json.decode(response.body.toString()));
            List<Pages> list = result.query.pages;
            yield SearchStateSuccess(list);
          // }

        } catch (error) {
         /* yield error is SearchResultError
              ? SearchStateError(error.message)
              :*/ SearchStateError('something went wrong');
        }
      }
    }
  }
}
