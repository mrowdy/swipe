library swipe;

import 'dart:html';
import 'dart:async';


class Swipe {
  
  /* options */
  int speed = 300;
  bool disableScroll = false;   
  
  Element _container;
  Element _wrapper;
  List<Element> _slides = new List<Element>();
  Map<int, int> _slidePos = new Map<int, int>();
  int _width;
  int _index = 0;
  Point _start;
  Point _delta;
  int _time = 0;
  bool _isScrolling;

  StreamController _onSwipeStart = new StreamController.broadcast();
  StreamController _onSwipeEnd = new StreamController.broadcast();
  StreamController _onSlideStart = new StreamController.broadcast();
  StreamController _onSlideEnd = new StreamController.broadcast();
  
  
  Swipe(this._container, {int index: 0}){
    _index = index;
    _setup();
    _handleEvents();
  }
  
  void prev() {
    if(_index > 0){
      slide(_index-1);
    }
  }

  void next() {
    if(_index < length - 1){
      slide(_index+1);
    }
  }
  
  void slide(int to, [int slideSpeed = 0]) {
    
    if (_index == to){
      return;
    }

    int direction = (_index-to).abs() ~/ (_index-to);
    int diff = (_index-to).abs() - 1;
    
    while (diff-- > 0) {
      _move( _circle((to > _index ? to : _index) - diff - 1), _width * direction, 0);
    }

    to = _circle(to);
    
    int speed = slideSpeed != 0 ? slideSpeed : this.speed;
    _move(_index, _width * direction, speed);
    _move(to, 0, speed);

    _index = to;
  }
  
  void _setup() {
    _wrapper = _container.children[0];
    
    if(_wrapper == null){
      return;
    }
    _slides = _wrapper.children;
    
    if(length == 0){
      return;
    }
   
    _width = _container.offsetWidth;
    _wrapper.style.width = '${_width * length}px';

    int pos = length;
    
    while(pos-- > 0) {

      Element slide = _slides[pos];
      
      slide.style.width = '${_width}px';
      slide.dataset['index'] = pos.toString();
    
      _move(pos, _index > pos ? -_width : (_index < pos ? _width : 0), 0);
    }
    
    _container.style.visibility = 'visible';
        
  }
  
  void _move(int index, int dist, int speed) {
    _translate(index, dist, speed);
    _slidePos[index] = dist;
  }
  
  void _translate(int index, int dist, int speed) {
    if(index < 0 || index > length - 1){
      return;
    }
    _slides[index].style
      ..transitionDuration = '${speed}ms'
      ..transform = 'translate(${dist}px, 0) translateZ(0)';
  }
  
  int _circle(int index){
    return (length + (index % length)) % length;
  }
  
  void _handleEvents() {
    _wrapper.onTouchStart.listen(_startEvent);
    _wrapper.onTouchMove.listen(_moveEvent);
    _wrapper.onTouchEnd.listen(_stopEvent);
  }
  
  void _startEvent(TouchEvent event) {
    _start = new Point(event.touches[0].page.x, event.touches[0].page.y);
    _onSwipeStart.add(_start);
    _time = new DateTime.now().millisecondsSinceEpoch;
    _isScrolling = null;
  }
  
  void _stopEvent(Event event) {
    if(_delta == null || _isScrolling == true){
      return;
    }

    int duration = new DateTime.now().millisecondsSinceEpoch - _time;

    bool isValidSlide =
        ( duration < 250 && _delta.x.abs() > 20 )       
        || _delta.x.abs() > _width/2;
        
    bool isPastBounds =
        _index == 0 && _delta.x > 0
        || _index == length - 1 && _delta.x < 0;
            
    bool direction = _delta.x < 0;
    
    if (isValidSlide && !isPastBounds) {
      _onSwipeEnd.add(_delta);
      if (direction) { // slide right
        _move(_index-1, -_width, 0);
        _move(_index, _slidePos[_index]-_width, speed);
        _move(_circle(_index+1), _slidePos[_circle(_index+1)]-_width, speed);
        _index = _circle(_index+1);
  
      } else {  // slide Left
        _move(_index+1, _width, 0);
        _move(_index, _slidePos[_index]+_width, speed);
        _move(_circle(_index-1), _slidePos[_circle(_index-1)]+_width, speed);
        _index = _circle(_index-1);
      }
    } else {
      _move(_index-1, -_width, speed);
      _move(_index, 0, speed);
      _move(_index+1, _width, speed);
    }
  }
  
  void _moveEvent(TouchEvent event) {
    if ( event.touches.length > 1){
      return;
    }

    if (disableScroll){
      event.preventDefault();
    };

    _delta =  new Point(
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
    if((_index == 0 && _delta.x > 0)
       || (_index == length -1 && _delta.x < 0))
    { 
      return;
    }
    
    if(_index > 0){
      _translate(_index-1, _delta.x + _slidePos[_index-1], 0);
    }
    
    _translate(_index, _delta.x + _slidePos[_index], 0);
    
    if(_index < length - 1){
      _translate(_index+1, _delta.x + _slidePos[_index+1], 0);
    }    
  }
  
  int get length => _slides.length;
  int get pos => _index;
  Stream get onSwipeStart => _onSwipeStart.stream;
  Stream get onSwipeEnd => _onSwipeEnd.stream;
  Stream get onSlideStart => _onSlideStart.stream;
  Stream get onSlideEnd => _onSlideEnd.stream;
}