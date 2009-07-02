$.sexyButton = function(text, element_class) {  
  return $('<a href="#" class="button ' + element_class + '">'+ text +'</a>').prepend('<span class="btn_left"></span>').append('<span class="btn_right"></span>');
}

jQuery(document).ready(function(){
  
  $('a.button').each(function () {
    $(this).prepend('<span class="btn_left"></span>');
    $(this).append('<span class="btn_right"></span>');
  });

  
  $('input[type=submit]').each(function () {
    $(this).wrap('<div class="submit_button"></div>');
    $(this).parent().prepend('<span class="btn_left"></span>');
    $(this).parent().append('<span class="btn_right"></span>');
  });
  
	
	// BRIEF CREATION SECTION

  $('.help_message').hide();
  
  $('.brief_item textarea').focus(function () {
    $(this).parent().siblings('.help_message').fadeIn();
  });
  
  $('.brief_item textarea').blur(function () {
    $(this).parent().siblings('.help_message').fadeOut();
  });
    
  $('.optional_brief_item').hide();
  
  $('.brief_item').each(function() {
    if (!$(this).hasClass('optional_brief_item') && $($(this).nextAll('.brief_item')[0]).hasClass('optional_brief_item')) {         
      $(this).append($.sexyButton('Add detail', 'show_question_details'));
      $(this).append('<div class="clear"></div>');
    };
  });
  
  $('.brief_item a.show_question_details').click(function(){
      $(this).hide();
      
      var hidden = $(this).parent().nextAll('.brief_item');
      
      for (var i=0; i < hidden.length; i++) {
        $(hidden[i]).fadeIn();
        if (!$(hidden[i+1]).hasClass('optional_brief_item')) { break };
      };
          
      return false;
    });
    
});

