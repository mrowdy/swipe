import 'dart:html';
import 'lib/swipe.dart';

Swipe swipe;

void main() {
  Element slider = querySelector('#slider');
  swipe = new Swipe(slider);
  swipe.slide(1, 0);
  swipe.slide(3, 0);
  swipe.slide(1, 0);
}
