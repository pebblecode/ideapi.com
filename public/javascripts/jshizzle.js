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
	var timeout = setTimeout(function () { element.fadeOut(); }, 3000);
	
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
      var on_text = "+ more"
      var off_text = "- hide"
      
      if (!$(this).hasClass('optional_brief_item') && $($(this).nextAll('.brief_item')[0]).hasClass('optional_brief_item')) {         
        
        $(this).append('<p><a href="#" class="show_question_details">'+on_text+'</a></p>').parent().find('.brief_item a.show_question_details').click(function(){
            ($(this).text() == on_text) ? $(this).text(off_text) : $(this).text(on_text);

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
      $(this).css('left', ((i * 132)) + "px");
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
    
    $('#edit_brief_details p.cancel').click(function (){
      $(this).parent().parent().slideToggle('slow');
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
    
    $('.recent_activity').each(function () {  $(this).attr("over_text", $(this).text()); }).click(function () {
      
      var on_text = $(this).attr("over_text"); 
      var _parent = $(this).parent();
      
      if ($(this).text() != on_text) {
        $(this).text(on_text);
        _parent.parent().removeClass('extended');
      } else {        
        _parent.parent().addClass('extended');
        $(this).text("hide activity");
      };
      
      _parent.nextAll('.brief_item_history').toggle();
      
      return false;
    });
    
    $('.brief_item_history').hide();
    
    $('.author_answer_form').each(function () {      
      $(this).before('<p class="submit show_author_answer_form"><input type="submit" value="answer"/></p>').parent().find('.show_author_answer_form input').click(function () {
        $(this).parent().next('.author_answer_form').fadeIn();
        $(this).parent().fadeOut();
        return false;
      });
    
    }).hide();
    
    if ($('.brief_item_history').length > 0) {
      $('.brief h2').append('<a href="#">expand / collapse all</a>').find('a').click(function () { $('.brief_item_history').toggle('400') });
    }
    
    // DISCUSS
    
    $('.brief_item_filter').each(function () {
      $(this).find('select').change(function () { 
        $(this).parent().submit();
      });
      $(this).find('input[type=submit]').hide();
    });
    
    $('p.submit').corners();
    
    $('a[rel*=facebox]').each(function () { $(this).attr("href", $(this).attr("href") + ".js"); }).facebox(
      {loadingImage: '/images/fb/loading.gif' , closeImage: '/images/fb/closelabel.gif'}
    );
    
    $('input, textarea').each(function () {
      if ($(this).attr('title') != "" && $(this).val() == "") {
        
        $(this).val($(this).attr('title'));
        
        $(this).focus(function () {
          if ($(this).val() == $(this).attr('title')) {
            $(this).addClass('').val('');
          };
        });

        $(this).blur(function () {
          if ($(this).val() == "") {
            $(this).val($(this).attr('title'));
          }
        });
        
      };
    });
});


