import 'dart:html';
import 'lib/swipe.dart';

Swipe swipe;

void main() {
  Element slider = querySelector('#slider');
  swipe = new Swipe(slider, index: 2);
  swipe.disableScroll = false;
  swipe.speed = 300;
  
  querySelector('#next').onClick.listen((_) => swipe.next());
  querySelector('#prev').onClick.listen((_) => swipe.prev());
  
  List<Element> nav = querySelectorAll('#nav button');
  nav.forEach((el){
    int index =  int.parse(el.dataset['index']);
    el.onClick.listen((MouseEvent evt){
      swipe.slide(index);
      print(swipe.pos);
    });
  });
  
  swipe.onSwipe.listen((point){
    print('swipe end: ${point.toString()}');
  });
  
  swipe.onSlideStart.listen((index){
    print('slide start with index: $index');
  });
  
  swipe.onSlideEnd.listen((index){
    print('slide end with index: $index');
  });
}
