part of swipe;

class Slide{
  Element element;
  
  Slide(this.element);
  
  int get width => element.offsetWidth;
}