import 'main.dart';

class RequestRecommendSongs extends VoidAction {}

class RequestRecommendSongsSuccess extends ActionType<List<dynamic>> {
  final List<dynamic> data;

  RequestRecommendSongsSuccess(this.data) : super(payload: data);
}
