# Gritter for AngularJS
Gritter is an awesome plugin written by Jordan Boesch. I decided I wanted to use it in an AngularJS project at work, which is what spawned this version of his library. Currently, this is working with AngularJS 1.1.5.

To install this with bower use:
``` bower install gritter ```

Here's a sample AngularJS directive for Gritter (I had to modify the original library to get code like this working, so you'll need my version of the library for this to work).

Adding a regular notice:
```javascript
angular.module('ngApp')
  .directive('gritterAdd', function () {
    return {
      restrict: 'A',
      link: function (scope, element) {
        // Bind gritter to a click event
        element.bind('click', function () {
          element.gritter.add({
            title: 'This is a regular notice!',
            text: 'This will fade out after a certain amount of time. Vivamus eget tincidunt velit. Cum sociis natoque penatibus et <a href="#" style="color:#ccc">magnis dis parturient</a> montes, nascetur ridiculus mus.',
            image: 'http://a0.twimg.com/profile_images/59268975/jquery_avatar_bigger.png',
            sticky: false,
            time: ''
          });
        });
      }
    };
  });
```

The HTML you would use on the page to trigger the gritterAdd directive:
```html
<a href="#" gritter-add>Gritter Regular Notification</a>
```

Adding a sticky notice:
```javascript
angular.module('ngApp')
  .directive('gritterAddSticky', function () {
    return {
      restrict: 'A',
      link: function (scope, element) {
        // Bind gritter to a click event
        element.bind('click', function () {
          element.gritter.add({
            title: 'This is a sticky notice!',
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus eget tincidunt velit. Cum sociis natoque penatibus et <a href="#" style="color:#ccc">magnis dis parturient</a> montes, nascetur ridiculus mus.',
            image: 'http://s3.amazonaws.com/twitter_production/profile_images/132499022/myface_bigger.jpg',
            sticky: true,
            time: '',
            class_name: 'my-sticky-class'
          });
        });
      }
    };
  });
```

The HTML you would use on the page to trigger the gritterAddSticky directive:
```html
<a href="#" gritter-add-sticky>Gritter Sticky Notification</a>
```

Similar directives could be written for the other functions such as gritter.remove, gritter.removeAll or for properties like gritter.options.


# Gritter for jQuery 

A small growl-like notification plugin for jQuery
- http://boedesign.com/blog/2009/07/11/growl-for-jquery-gritter/

## Change Log

### Changes in 1.8.0 (October 22, 2013)

* New option: `addPosition` - Ability to specify whether new notifications are added to the 'top' or to the 'bottom'.

### Changes in 1.7.6 (June 17, 2013)

* Added options to always show the close button (hover_state = 'no'), and to customize the close button html (close_button = 'some html'. - Jason Feriante

### Changes in 1.7.5 (June 6, 2013)

* Fixing bug where AngularJS was unable to find the gritter functions and properties. - Jason Feriante

### Changes in 1.7.4 (February 24, 2012)

* Fixing bug where click event was being bound multiple times on hover. The result was the beforeClose callback being called multiple times. Thanks for commit aossowski!

### Changes in 1.7.3 (December 8, 2011)

* Added $.gritter.options.class_name option
* Added 'gritter-light' class_name option to use light messages instead of dark ones

### Changes in 1.7.2 (December 2, 2011)

* Added option to return false on "before_open" callback to determine whether or not to show the gritter message (good for setting a max)

### Changes in 1.7.1 (March 29, 2011)

* Dropped IE6 support
* Added position option to global options (bottom-left, top-left, top-right, bottom-right)

### Changes in 1.7 (March 25, 2011)

* Fixed 404 issue in the css when fetching '.' as an image
* Added callback parameter in before_close and after_close callbacks to determine whether it was closed manually by clicking the (X)

### Changes in 1.6 (December1, 2009)

* Commented code using JSDOC
* Major code cleanup/re-write
* Made it so when you hit the (X) close button, the notification slides up and vanishes instead of just vanishing
* Added optional "class_name" option for $.gritter.add() to apply a class to a specific notification
* Fixed IE7 issue pointed out by stoffel (http://boedesign.com/blog/2009/07/11/growl-for-jquery-gritter/) 

### Changes in 1.5 (October 21, 2009)

* Renamed the global option parameters to make more sense
* Made it so the global options are only being ran once instead of each $.gritter.add() call

### Changes in 1.4 (October 20, 2009)

* Added callbacks (before_open, before_close, after_open, after_close) to the gritter notifications
* Added callbacks (before_close, after_close) to the removeAll() function
* Using 1 image for the CSS instead of 5 (Thanks to Ozum Eldogan)
* Added option to over-ride gritter global options with $.extend

### Changes in 1.3 (August 1, 2009)

* Fixed IE6 positioning bug

### Changes in 1.2 (July 13, 2009)

* Fixed hover bug (pointed out by Beel & tXptr on the comments)
