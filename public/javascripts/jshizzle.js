jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$.sexyButton = function(text, element_class) {  
  return $('<a href="#" class="button ' + element_class + '">'+ text +'</a>').prepend('<span class="btn_left"></span>').append('<span class="btn_right"></span>');
}

$.fn.fadeToggle = function(speed, easing, callback) { 
   return this.animate({opacity: 'toggle'}, speed, easing, callback); 
};

$.fn.flashNotice = function () {
	$(this).hide();
	$(this).fadeIn();
	
	var element = $(this);
	var timeout = setTimeout(function () { element.fadeOut(); }, 5000);
	
	$(this).click(function () {
	  clearTimeout(timeout);
	  $(this).fadeOut();
	});
}

$.fn.showNotice = function (message) {	 
	$(this).html("<p class='notice'>"+message+"</p>")
	$(".notice", this).flashNotice();
}

jQuery(document).ready(function(){
  
    $(".notice, .error").flashNotice();  
  
    $('a.button').each(function () {
      $(this).prepend('<span class="btn_left"></span>');
      $(this).append('<span class="btn_right"></span>');
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
        $(this).append('<p><a href="#" class="show_question_details">click here to add detail</a></p>').find('.brief_item a.show_question_details').click(function(){
            ($(this).text() == 'click here to add detail') ? $(this).text('hide details') : $(this).text('click here to add detail');

            var hidden = $(this).parent().parent().nextAll('.brief_item');

            for (var i=0; i < hidden.length; i++) {
              $(hidden[i]).fadeToggle();
              if (!$(hidden[i+1]).hasClass('optional_brief_item')) { break };
            };

            return false;
        });
        $(this).append('<div class="clear"></div>');
      };
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
    
    $('#edit_brief #edit_brief_details').hide();
    
    $('a[href=#edit_brief_details]').click(function () { 
      $('#edit_brief #edit_brief_details').slideToggle('slow');
      return false;
    });
    
    $('.note').append('<a href="#" class="hide_message">hide this message</a>').find('a.hide_message').click(function () { $(this).parent().fadeOut(); return false; });
    
    $(".brief_timeline li span").corners();  
        
    $('.speech').append('<span class="bubble" />').corners();
    
    $('.revision h5').corners();
    
    $('.revision h5').click(function () {
      $(this).siblings('p.changes').toggle();
    }).siblings('p.changes').toggle();

    $('.current_revision span.revision').click(function () {
      $(this).parent().parent().parent().find('.brief_item_history').toggle();
    }).corners();
    
    $('.toggle_ask_question').click(function () {
      $(this).parent().next('.ask_question').toggle();
      return false;
    }).click();
    
    $('.toggle_history').click(function () {
      $(this).parent().nextAll('.brief_item_history').toggle();
      return false;
    }).click();
    
    $('.author_answer_form').each(function () {      
      $(this).before('<p class="submit show_author_answer_form"><input type="submit" value="answer"/></p>').parent().find('.show_author_answer_form input').click(function () {
        $(this).parent().next('.author_answer_form').fadeIn();
        $(this).parent().fadeOut();
        return false;
      });
    
    }).hide();
    
    $('.brief h2').append('<a href="#">expand / collapse all</a>').find('a').click(function () { $('.brief_item_history').toggle('400') });
    
    $('p.submit').corners();
    
    $('a[rel*=facebox]').each(function () { $(this).attr("href", $(this).attr("href") + ".js"); }).facebox(
      {loadingImage: '/images/fb/loading.gif' , closeImage: '/images/fb/closelabel.gif'}
    );
});


