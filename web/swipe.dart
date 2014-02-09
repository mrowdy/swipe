import 'dart:html';
import 'lib/swipe.dart';

Swipe swipe;

void main() {
  Element slider = querySelector('#slider');
  swipe = new Swipe(slider, index: 2);
  swipe.disableScroll = false;
  swipe.speed = 200;
  
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
}
