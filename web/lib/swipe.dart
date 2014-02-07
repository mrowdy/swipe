library swipe;

import 'dart:html';

part 'slide.dart';

class Swipe {
  Element container;
  List<Slide> slides = new List<Slide>();
  int index = 1;
  bool continuous = true;
  
  Swipe(this.container){
    setup();
  }
  
  void setup(){
    List<Element> slides = container.querySelectorAll('.swipe-wrap div');
    slides.forEach((Element element){
      this.slides.add(new Slide(element));
    });
  } 
  
  void slide(int target, int speed){
    if (slides.length < 2){
      continuous = false;
    }
    
    if(index == target){
      return;
    }
    
    // 1: backward, -1: forward
    int direction = (index - target).abs() ~/ (index - target);
 
    resizeWrapper();
  }
  
  void resizeWrapper(){
    Element wrapper = container.querySelector('.swipe-wrap');
    wrapper.style.width = '${slides[0].width * slides.length}px';
  }
  
  void prev(){
    index++;
  }
  
  void next(){
    index--;
  }
  
  int loop(){
    return (slides.length + (index % slides.length)) % slides.length;
  }
  
  int get length => slides.length;
}