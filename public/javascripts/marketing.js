
$(document).ready(function(){
  // For debugging: Add grid on logo click
  // turn_on_logo_grid_toggle();
  
  // Add inline labels
  $(".infield-labels label").inFieldLabels();
  
  // Account tab
  {    
    $("#account-button").click(function() {                  
      var account_form = $(this).siblings("#account-contents");
      
      if ($(account_form).filter(":visible").size() > 0) { // Account is visible
        $(this).parent().removeClass("active");
        $(account_form).hide();
      } else { // Account is hidden
        $(this).parent().addClass("active");
        $(account_form).show();
      }      
      
      return false;
    });
  }

  // Lightbox
  $("a[rel=lightbox]").lightBox({
    txtImage: "",
    imageLoading: '/images/lightbox-images/lightbox-ico-loading.gif',
    imageBtnClose: '/images/lightbox-images/close.png',
    imageBtnPrev: '/images/lightbox-images/prev.png',
    imageBtnNext: '/images/lightbox-images/next.png',
    imageBlank: '/images/lightbox-images/lightbox-blank.gif'
  }); // Select all links that contains lightbox in the attribute rel
  
});

// For debugging
function turn_on_logo_grid_toggle() {
  $("#logo").click(function() {
    turn_on_grid();
    return false;
  });
}
function turn_on_grid() {
  var grid_overlay = $("#grid-overlay");
  if (grid_overlay.size() == 0) {
    $("#container").append("<div id='grid-overlay'></div>");

    $("#grid-overlay").click(function() {
      $(this).remove();
    });    
  }
}