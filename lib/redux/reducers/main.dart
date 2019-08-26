import 'package:flutter/material.dart';
import 'package:flutter_net_music/net/netApi.dart';
import 'package:flutter_net_music/redux/actions/main.dart';
import 'package:flutter_net_music/theme.dart';
import 'package:redux/redux.dart';

@immutable
class AppState {
  final ThemeState themeState;


  const AppState({this.themeState});
}

AppState _initReduxState() {
  return AppState(
      themeState: ThemeState.initState(),
  );
}

AppState reduxReducer(AppState state, action) =>
    AppState(themeState: ThemeReducer().redux(state.themeState, action));

abstract class ViewModel {
  final Store<AppState> store;

  ViewModel({this.store});
}

class StoreContainer {
  static final Store<AppState> global = reduxStore();

  static dispatch(dynamic action) => global.dispatch(action);
}

Store reduxStore() => Store<AppState>(reduxReducer,
    initialState: _initReduxState(), distinct: true);

abstract class Reducer<T> {
  T redux(T state, ActionType action);
}

abstract class RequestState<T> {
  final bool isLoading;

  final RequestFailureInfo info;

  final T mainDate;

  RequestState({this.mainDate, this.isLoading, this.info});

  bool isSuccess() => mainDate != null && info != null && !isLoading;

  bool isFailure() => info != null;
}
