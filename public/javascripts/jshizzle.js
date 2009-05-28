jQuery(document).ready(function(){
	
	// BRIEF CREATION SECTION
	
	$('.section h3').click(function() {
		$(this).next().slideToggle('fade', function (){
		  $(this).find('.answer textarea:first').focus();
		});
		return false;
	}).next().hide();
	
	var current_location = document.location.toString();
  if (current_location.match('#section')) { 
    $('#' + current_location.split('#')[1] + ' h3').click();
  } else {
    $('.section:first h3').next().toggle();
  }
	
	$('.question_help').hide();
	
	$('.answer textarea').focus(function () {
	  $(this).parent().siblings('.question').find('.question_help').fadeIn();
	});

  $('.answer textarea').blur(function () {
	  $(this).parent().siblings('.question').find('.question_help').fadeOut();
  });
  
  $('.optional_question').hide();
  
  $('.section_question').each(function() {
    if (!$(this).hasClass('optional_question') && $(this).next().hasClass('optional_question')) {
      $(this).append("<a href='#' class='button show_question_details'>Add detail</a>");
    };
  });
  
  $('.section_question a.show_question_details').click(function(){
    $(this).hide();
    
    var hidden = $(this).parent().nextAll('.section_question');
    
    for (var i=0; i < hidden.length; i++) {
      $(hidden[i]).fadeIn();
      if (!$(hidden[i+1]).hasClass('optional_question')) { break };
    };
        
    return false;
  });
  
  // END BRIEF CREATION SECTION
	  
  // for the back end.
  $("select[multiple]").asmSelect({
    animate: true
  });

  	
});

