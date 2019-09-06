abstract class ActionType<T>{
  final T payload;

  ActionType({this.payload});

  @override
  String toString() => '$runtimeType(${payload?.runtimeType}),payload:$payload';
}

class VoidAction extends ActionType<void> {}