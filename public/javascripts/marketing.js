
$(document).ready(function(){
  // For debugging: Add grid on logo click
  turn_on_logo_grid_toggle();
  
  $("#slider").easySlider({
  	auto: false,
  	continuous: false,
  	nextId: "slider-next",
  	prevId: "slider-prev"
  });
  

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