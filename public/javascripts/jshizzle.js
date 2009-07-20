$.sexyButton = function(text, element_class) {  
  return $('<a href="#" class="button ' + element_class + '">'+ text +'</a>').prepend('<span class="btn_left"></span>').append('<span class="btn_right"></span>');
}

$.fn.fadeToggle = function(speed, easing, callback) { 
   return this.animate({opacity: 'toggle'}, speed, easing, callback); 
};

jQuery(document).ready(function(){
  
    $('a.button').each(function () {
      $(this).prepend('<span class="btn_left"></span>');
      $(this).append('<span class="btn_right"></span>');
    });
  
    
    // $('input[type=submit]').each(function () {
    //   $(this).wrap('<div class="submit_button"></div>');
    //   $(this).parent().prepend('<span class="btn_left"></span>');
    //   $(this).parent().append('<span class="btn_right"></span>');
    // });
  
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
        $(this).append('<p><a href="#" class="show_question_details">click here to add detail</a></p>');
        $(this).append('<div class="clear"></div>');
      };
    });
    
    $('.brief_item a.show_question_details').click(function(){
        ($(this).text() == 'click here to add detail') ? $(this).text('hide details') : $(this).text('click here to add detail');
        
        var hidden = $(this).parent().parent().nextAll('.brief_item');
        
        for (var i=0; i < hidden.length; i++) {
          $(hidden[i]).fadeToggle();
          if (!$(hidden[i+1]).hasClass('optional_brief_item')) { break };
        };
            
        return false;
    });
    
    $('.brief_item_section').addClass('brief_item_section_tabbed');
    
    $('.brief_item_section_tabbed h3').each(function (i) {
      $(this).css('left', ((i * 136)) + "px");
    }).click(function () {
      $(this).siblings('ul').show();
      $(this).parent().siblings().find('ul').hide();
      $(this).parent().siblings().find('h3').removeClass('selected');
      $(this).addClass('selected');
    }).next().hide();
    
    $('.brief_item_section_tabbed h3:first').addClass('selected');
    $('.brief_item_section_tabbed h3:last').css('border-right','1px solid #ccc');
    $('.brief_item_section_tabbed ul:first').show();
    
    // BRIEF EDIT
    
    $('#edit_brief .brief_details').hide();//.before('<p><a class="show_brief_details" href="#brief_details">toggle brief details</a></p>');
    //$('#edit_brief a.show_brief_details').click(function () { $('#edit_brief .brief_details').toggle(); return false; })
    
    $('.note').append(' <a href="#" class="hide_message">hide this message</a>');
    $(' .note a.hide_message').click(function () { $(this).parent().fadeOut(); return false; });
    
    $(".brief_timeline li span").corners();  
    
    $('p.submit').corners();
    
    $('.speech').append('<span class="bubble" />').corners();

});


