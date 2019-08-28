import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef LoadBuilder = Widget Function(BuildContext context);

typedef ErrorBuilder<T> = Widget Function(BuildContext context, [T t]);

typedef ContentBuilder<T> = Widget Function(BuildContext context, T t);

class SingleFutureWidget<T> extends StatefulWidget {
  final ContentBuilder<T> child;

  final Future future;

  final Widget loading;

  final T initData;

  final Widget error;

  final LoadBuilder loadBuilder;

  final ErrorBuilder errorBuilder;

  const SingleFutureWidget(
      {Key key,
      this.child,
      @required this.future,
      this.loading,
      this.initData,
      this.error,
      this.loadBuilder,
      this.errorBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingleFutureWidgetState<T>();

  Widget buildContentView(BuildContext context, T t) {
    return child(context, t);
  }

  Widget buildErrorWidget(BuildContext context, T t) =>
      error ??
      (errorBuilder != null ? errorBuilder(context, t) : ErrorWidget());

  Widget buildLoadWidget(BuildContext context) =>
      loading ?? (loadBuilder != null ? loadBuilder(context) : WaveLoading());
}

class _SingleFutureWidgetState<T> extends State<SingleFutureWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.future,
      initialData: widget.initData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        var connectionState = snapshot.connectionState;
        Widget result;
        switch (connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            result = widget.buildLoadWidget(context);
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              result = widget.buildErrorWidget(context, snapshot.data);
            } else {
              return widget.buildContentView(context, snapshot.data);
            }
            break;
        }
        return result ?? widget.child(context, snapshot.data);
      },
    );
  }
}

/// 通用Loading
class WaveLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        itemBuilder: (_, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          );
        },
      ),
    );
  }
}

/// 通用ErrorWidget
///
class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

///错误回调
abstract class ErrorCallback {
  void retryCall();
}

/// Dio网络请求
@deprecated
class NetFutureWidget extends SingleFutureWidget<Map<String, dynamic>> {
  final ContentBuilder<Map<String, dynamic>> child;

  final Future future;

  final Widget loading;

  final Map<String, dynamic> initData;

  final Widget error;

  final LoadBuilder loadBuilder;

  final ErrorBuilder errorBuilder;

  const NetFutureWidget(
      {Key key,
      @required this.child,
      @required this.future,
      this.loading,
      this.initData,
      this.error,
      this.loadBuilder,
      this.errorBuilder})
      : super(
            key: key,
            child: child,
            future: future,
            loading: loading,
            initData: initData,
            error: error,
            loadBuilder: loadBuilder,
            errorBuilder: errorBuilder);

  @override
  Widget buildContentView(BuildContext context, Map<String, dynamic> t) {
    if (t.containsKey("code")) {
      var code = t["code"];
      if (code == 200) {
        return child(context, t);
      } else if (code == 301) {
        //todo 需要登录

      }
    }
    return buildErrorWidget(context, t);
  }
}

final Map emptyMap = Map();
