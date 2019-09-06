import 'dart:math';


int randomInt(int max,int skip){
  List<int> send = List.generate(max, (i)=>i)..remove(skip);
  return send[Random().nextInt(send.length)];
}