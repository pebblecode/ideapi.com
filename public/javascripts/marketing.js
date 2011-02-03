
$(document).ready(function(){
  // For debugging: Add grid on logo click
  // turn_on_logo_grid_toggle();
  
  $("#slider").easySlider({
  	auto: false,
  	continuous: true,
  	nextId: "slider-next",
  	prevId: "slider-prev"
  });
  // jQuery SmoothScroll | Version 10-04-30
  $('a[href*=#]').click(function(e) {

     // duration in ms
     var duration=1000;

     // easing values: swing | linear
     var easing='swing';

     // get / set parameters
     var newHash=this.hash;
     var target=$(this.hash).offset().top;
     var oldLocation=window.location.href.replace(window.location.hash, '');
     var newLocation=this;

     // make sure it's the same location      
     if(oldLocation+newHash==newLocation)
     {
        // set selector
        var animationSelector = null;
        if($.browser.safari) animationSelector='body:not(:animated)';
        else animationSelector='html:not(:animated)';

        // animate to target and set the hash to the window.location after the animation
        $(animationSelector).animate({ scrollTop: target }, duration, easing, function() {

           // add new hash to the browser location
           window.location.href=newLocation;
        });

        // cancel default click action
        e.preventDefault();
        return false;
     }
  });
  $("a.overlay-video-trigger").overlay();
  
  
});

// For debugging
function turn_on_logo_grid_toggle() {
  $("#logo").click(function(e) {
    turn_on_grid();
    e.preventDefault();
  });
}
function turn_on_grid() {
  $('.container').toggleClass('showgrid');
}