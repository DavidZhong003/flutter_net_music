import 'main.dart';

class ChangeBackImageAction extends ActionType<String> {
  final String image;

  ChangeBackImageAction(this.image) : super(payload: image);
}
