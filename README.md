swipe
=====

A swipe class for mobile navigation or slideshows.

Based on https://github.com/bradbirdsall/Swipe

##Usage

You need two containers for your slides

``` html
<div id="slider">
  <div>
    <div> Slide 1</div>
    <div> Slide 2</div>
    <div> Slide 3</div>
  </div>
</div>
```

The containing div gets passed to the Swipe function like this:

``` dart
  Element slider = querySelector('#slider');
  Swipe swipe = new Swipe(slider);
```

You can pass the starting slide to the constructor

``` dart
  Swipe swipe = new Swipe(slider, index: 2);
```

## Config Options

-	**speed** Integer *(default:300)* - speed of slide animation in milliseconds.

- **disableScroll** Boolean *(default:false)* - stop any touches on this container from scrolling the page

- **minSwipeDistance** Integer *(default:20)* - minimal distance to trigger swipe

- **maxSwipeDuration** Integer *(default:300)* - maximum time to trigger swipe

## Getter

- **length** - returns amount of slides
- **pos** -  returns current slide position

## Streams

- **onSwipe** - Fires when a swipe is detected
- **onSlideStart** - Fires when the slide animation starts
- **StreamController** - Fires when the slide animation stops


## Methods

- **prev()** - manually slide to the left
- **next()** - manually slide to the right
- **slide(int to, [int slideSpeed = 0])** - manually slide to position





