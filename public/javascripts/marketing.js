
$(document).ready(function(){
  // For debugging: Add grid on logo click
  $("#logo").click(function() {
    $("#container").append("<div id='grid-overlay'></div>");
    
    $("#grid-overlay").click(function() {
      $(this).remove();
    });
    return false;
  });
  
  $(".infield-labels label").inFieldLabels();
  
});
