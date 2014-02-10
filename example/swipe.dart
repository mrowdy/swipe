import 'dart:html';
import 'package:swipe/swipe.dart';

Swipe swipe;
Element slider;
Element prev;
Element next;

void main() {
  slider = querySelector('#slider');
  swipe = new Swipe(slider, index: 1);

  next = querySelector('.next');
  next.onClick.listen((_){
    swipe.next();
    updateNav();  
  });
  
  prev = querySelector('.prev');
  prev.onClick.listen((_){
    swipe.prev();
    updateNav();  
  });;


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

void updateNav(){
  if(swipe.pos == 0){
    prev.classes.add('hide');
  } else {
    prev.classes.remove('hide');
  }
  
  if(swipe.pos == swipe.length -1){
    next.classes.add('hide');
  } else {
    next.classes.remove('hide');
  }
}
