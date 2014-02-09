library swipe;

import 'dart:html';

part 'vector.dart';

class Swipe {
  Element _container;
  Element _wrapper;
  
  List<Element> _slides = new List<Element>();
  Map<int, int> slidePos = new Map<int, int>();
  int width;
  int get length => _slides.length;
  int index = 2;
  int speed = 300;
  bool disableScroll = false;
   
  Vector _start;
  Vector _delta;
  int _time = 0;
  bool _isScrolling;
  
  
  Swipe(this._container){
    _setup();
    _handleEvents();
  }
  
  void _setup(){
    _wrapper = _container.children[0];
    
    if(_wrapper == null){
      return;
    }
    _slides = _wrapper.children;
    
    if(length == 0){
      return;
    }
   
    width = _container.offsetWidth;
    _wrapper.style.width = '${width * length}px';

    int pos = length;
    
    while(pos-- > 0) {

      Element slide = _slides[pos];
      
      slide.style.width = '${width}px';
      slide.dataset['index'] = pos.toString();
    
      _move(pos, index > pos ? -width : (index < pos ? width : 0), 0);
    }
    
    _container.style.visibility = 'visible';
        
  }
  
  void _move(int index, int dist, int speed) {
    _translate(index, dist, speed);
    slidePos[index] = dist;
  }
  
  void _translate(int index, int dist, int speed) {
    if(index < 0 || index > _slides.length - 1){
      return;
    }
    _slides[index].style
      ..transitionDuration = '${speed}ms'
      ..transform = 'translate(${dist}px, 0) translateZ(0)';
  }
  
  int _circle(int index){
    return (_slides.length + (index % _slides.length)) % _slides.length;
  }
  
  void prev() {
    if(index != 0){
      _slide(index-1);
    }
  }

  void next() {
    if(index < _slides.length - 1){
      _slide(index-1);
    }
  }
  
  void _slide(int to, [int slideSpeed = 0]) {
    
    if (index == to){
      return;
    }

    int direction = (index-to) ~/ (index-to);
    int diff = (index-to) - 1;

    while (diff-- > 0){
      _move( _circle((to > index ? to : index) - diff - 1), width * direction, 0);
    }

    to = _circle(to);
    
    int speed = slideSpeed != 0 ? slideSpeed : this.speed;
    _move(index, width * direction, speed);
    _move(to, 0, speed);

    index = to;
  }
  
  void _handleEvents(){
    _wrapper.onTouchStart.listen(_startEvent);
    _wrapper.onTouchMove.listen(_moveEvent);
    _wrapper.onTouchEnd.listen(_stopEvent);
  }
  
  void _startEvent(TouchEvent event){
    //print('start');
    _start = new Vector(event.touches[0].page.x, event.touches[0].page.y);
    _time = new DateTime.now().millisecondsSinceEpoch;
    _isScrolling = null;
  }
  
  void _stopEvent(Event event){
    //print('stop');
    
    if(_delta == null || _isScrolling == true){
      return;
    }

    int duration = new DateTime.now().millisecondsSinceEpoch - _time;

    bool isValidSlide =
        ( duration < 250 && _delta.x.abs() > 20 )       
        || _delta.x.abs() > width/2;
        
    bool isPastBounds =
        index == 0 && _delta.x > 0
        || index == _slides.length - 1 && _delta.x < 0;
            
    bool direction = _delta.x < 0;
    
    if (isValidSlide && !isPastBounds) {
      if (direction) { // slide right
        _move(index-1, -width, 0);
        _move(index, slidePos[index]-width, speed);
        _move(_circle(index+1), slidePos[_circle(index+1)]-width, speed);
        index = _circle(index+1);
  
      } else {  // slide Left
        _move(index+1, width, 0);
        _move(index, slidePos[index]+width, speed);
        _move(_circle(index-1), slidePos[_circle(index-1)]+width, speed);
        index = _circle(index-1);
      }
    } else {
      _move(index-1, -width, speed);
      _move(index, 0, speed);
      _move(index+1, width, speed);
    }
  }
  
  void _moveEvent(TouchEvent event){
    event.preventDefault();
    if ( event.touches.length > 1){
      return;
    }

    if (disableScroll){
      event.preventDefault();
    };

    _delta =  new Vector(
        event.touches[0].page.x - _start.x, 
        event.touches[0].page.y - _start.y
     );

    if ( _isScrolling == null) {
      _isScrolling = _delta.x.abs() < _delta.y.abs();
    }

    if (_isScrolling) {
      return;
    }
   
    event.preventDefault();
    if((index == 0 && _delta.x > 0)
       || (index == _slides.length -1 && _delta.x < 0))
    { 
      return;
    }
    
    if(index > 0){
      _translate(index-1, _delta.x + slidePos[index-1], 0);
    }
    _translate(index, _delta.x + slidePos[index], 0);
    if(index < _slides.length - 1){
      _translate(index+1, _delta.x + slidePos[index+1], 0);
    }    
  }
}