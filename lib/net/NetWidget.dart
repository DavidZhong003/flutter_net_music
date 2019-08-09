import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef LoadBuilder = Widget Function(BuildContext context);

typedef ErrorBuilder<T> = Widget Function(BuildContext context,
    [T t]);

class SingleFutureWidget<T> extends StatefulWidget {
  final Widget child;

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
            result = buildLoadWidget(context);
            break;
          case ConnectionState.done:

            if (snapshot.hasError) {
              result = buildErrorWidget(context);
            } else {
              return widget.child;
            }
            break;
        }
        return result ?? widget.child;
      },
    );
  }

  Widget buildErrorWidget(BuildContext context) => widget.error??widget.errorBuilder(context);

  Widget buildLoadWidget(BuildContext context) => widget.loading??widget.loadBuilder(context);
}
