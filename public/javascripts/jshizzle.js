jQuery(document).ready(function(){
	
	// BRIEF CREATION SECTION
	
	$('.brief_section .brief_section_title h3').click(function() {
		$(this).parent().next().slideToggle('fade', function (){
		  $(this).find('.brief_answer textarea:first').focus();
		});
		return false;
	}).parent().next().hide();
	
	var current_location = document.location.toString();
  if (current_location.match('#section')) { 
    $('#' + current_location.split('#')[1] + ' .brief_section_title').click();
  } else {
    $('.brief_section:first .brief_section_title').next().toggle();
  }
	
	$('.brief_question_help').hide();
	
	$('.brief_answer textarea').focus(function () {
	  $(this).parent().siblings('.brief_question').find('.brief_question_help').fadeIn();
	});

  $('.brief_answer textarea').blur(function () {
	  $(this).parent().siblings('.brief_question').find('.brief_question_help').fadeOut();
  });
  
  $('.optional_brief_question').hide();
  
  $('.brief_section_brief_question').each(function() {
    if (!$(this).hasClass('optional_brief_question') && $(this).next().hasClass('optional_brief_question')) {
      $(this).append("<a href='#' class='button show_question_details'>Add detail</a>");
    };
  });
  
  $('.brief_section_brief_question a.show_question_details').click(function(){
    $(this).hide();
    
    var hidden = $(this).parent().nextAll('.brief_section_brief_question');
    
    for (var i=0; i < hidden.length; i++) {
      $(hidden[i]).fadeIn();
      if (!$(hidden[i+1]).hasClass('optional_brief_question')) { break };
    };
        
    return false;
  });
  
  // END BRIEF CREATION SECTION
	  
  // for the back end.
  $("select[multiple]").asmSelect({
    animate: true
  });

  	
});

