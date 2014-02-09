import 'dart:html';
import 'lib/swipe.dart';

Swipe swipe;

void main() {
  Element slider = querySelector('#slider');
  swipe = new Swipe(slider);
  
}
