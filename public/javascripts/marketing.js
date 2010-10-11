
$(document).ready(function(){
  // For debugging: Add grid on logo click
  $("#logo").click(function() {
    $("#container").append("<div id='grid-overlay'></div>");
    
    $("#grid-overlay").click(function() {
      $(this).remove();
    });
    return false;
  });
  
  // Add inline labels
  $(".infield-labels label").inFieldLabels();
  
  // Account tab
  {    
    $("#account-button").click(function() {                  
      var account_form = $(this).prev("#account-form");
      
      if ($(account_form).filter(":visible").size() > 0) { // Account is visible
        $(this).parent().removeClass("active");
        $(this).text("Login");
        $(account_form).hide();
      } else { // Account is hidden
        $(this).parent().addClass("active");
        $(this).text("Close");
        $(account_form).show();
      }      
      
      return false;
    });
  }

  
});
