import 'dart:math';

import 'dart:ui';

bool colorComp(Color a, Color b) {
  print("a=$a,b=$b");
  int absR = a.red - b.red;
  int absG = a.green - b.green;
  int absB = a.blue - b.blue;
  double value= sqrt(absR * absR + absB * absB + absG * absG);
  print(value);
  return value < 255;
}
