
$(document).ready(function(){
  // For debugging: Add grid on logo click
  // $("#logo").click(function() {
  //   turn_on_grid();
  //   return false;
  // });
  
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

  
});

// For debugging
function turn_on_grid() {
  var grid_overlay = $("#grid-overlay");
  if (grid_overlay.size() == 0) {
    $("#container").append("<div id='grid-overlay'></div>");

    $("#grid-overlay").click(function() {
      $(this).remove();
    });    
  }
}