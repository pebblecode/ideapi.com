jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});

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

$.fn.feedback_form = function () {
  form = $(this).find('.wrap');
  
  $(this).find('.title a').click(function () {
    form.fadeToggle();
  });
  
  form.hide();
}


$.fn.trigger_help_message = function () {
  $(this).focus(function () {
    $(this).parent().siblings('.help_message').fadeIn();
  }).blur(function () {
    $(this).parent().siblings('.help_message').fadeOut();
  });
}

$.hideable_cookie_name = function (id) {
  return "_note_" + id; 
}

$.fn.hideable_note = function () {
  var el_id = $(this).attr('id');
  
  if ( !((el_id == "") || (el_id == undefined)) ) {    
    if ($.cookie($.hideable_cookie_name(el_id)) != null) {      
      $(this).remove();
    }
  };
  
  $(this).append('<a href="#" class="hide_message">hide</a>').find('a.hide_message').click(function () {
    
    if ($(this).parent().attr('id') != "") {      
      $.cookie($.hideable_cookie_name($(this).parent().attr('id')), 'hidden');        
    };
          
    $(this).parent().fadeOut(); 
  
    return false; 
  
  });
}


$.fn.edit_brief_item = function () {
  
  var link_on_state = "+";
  var link_off_state = "-";
  
  $(this).find('textarea').each( function () { 
    
    if ($(this).val() == "") {
      $(this).hide();

      $(this).parent().prev('h3').prepend('<a class="toggle_brief_edit awesome small blue" href="#'+$(this).attr("id")+'">'+ link_on_state +'</a>');
      $(this).parent().prev('h3').addClass('empty active');
      
      $(this).parent().prev('h3').find('a.toggle_brief_edit').click(function () {
        
        $(this).parent().parent().find('textarea').toggle();
        
        if ($(this).text() == link_on_state) {
          $(this).text(link_off_state);
          $(this).parent().removeClass('empty');
        } else {
          $(this).text(link_on_state);
          $(this).parent().addClass('empty');
        };
        
        return false;
        
      });
      
      $(this).parent().prev('h3').each(function () { $(this).css("cursor", "pointer"); }).click(function () {
        if ($(this).hasClass('active')) {
          $(this).find('a.toggle_brief_edit').click();
          $(this).css("cursor", "pointer");
        } else {
          $(this).css("cursor", "auto");
        }
      });
      
      //.click( function () { $(this).next('textarea').show(); } );
    };
    
    $(this).change(function () {
      if ($(this).val() != "") {
        $(this).parent().prev('h3').find('a.toggle_brief_edit').hide();
        $(this).parent().prev('h3').removeClass('active');
      } else {
        $(this).parent().prev('h3').find('a.toggle_brief_edit').show();       
        $(this).parent().prev('h3').addClass('active');
      }
    });
  
  });
}

$.fn.fold_activity_stream = function () {
  $(this).hide();
  
  $('a.toggle_activity_stream').click(function () {
    
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
    } else {
      $(this).addClass('active');
    };
    
    $(this).prev().toggle();
    
    return false;
  });
}

$.fn.delete_item = function (remove_item_class) {
  $(this).after('<a href="#" class="trash">Remove</a>');
  
  $(this).next('.trash').click(function () {
    data = {}
    data[$(this).prev(remove_item_class).attr('name')] = 1;
    $.put($(this).parents().filter('form').attr('action'), data, function (e) {
      
    }, 'js');
    return false;
  });
  
  $(this).hide();
}

jQuery(document).ready(function(){
  
    $(".notice, .error").flashNotice();  
    
    $('.help_message').hide();
    
    $('.brief_item textarea').trigger_help_message();
    
    $('.note').hideable_note();

    $(".brief_timeline li span").corners();  

    $('.speech').append('<span class="bubble" />').corners();
    
    $('.revision h5').corners();
    
    $('.revision h5').click(function () {
      $(this).siblings('p.changes').toggle();
    }).siblings('p.changes').toggle();

    // $('.current_revision span.revision').click(function () {
    //   $(this).parent().parent().parent().find('.brief_item_history').toggle();
    // }).corners();
    
    // $('.recent_activity').each(function () {  $(this).attr("over_text", $(this).text()); }).click(function () {
    //   
    //   var on_text = $(this).attr("over_text"); 
    //   var _parent = $(this).parent();
    //   
    //   if ($(this).text() != on_text) {
    //     $(this).text(on_text);
    //     _parent.parent().removeClass('extended');
    //   } else {        
    //     _parent.parent().addClass('extended');
    //     $(this).text("hide activity");
    //   };
    //   
    //   _parent.nextAll('.brief_item_history').toggle();
    //   
    //   return false;
    // });
    
    $('.brief_item_history').each(function () {
      $(this).find('ul').hide().before('<a href="#" class="expand_history">expand / collapse all</a>');
      $(this).find('a.expand_history').click(function () {
        $(this).next('ul').toggle();
        return false;
      });
    });
    
    $('.question .author_answer_form').each(function () { 
       
      $(this).before('<p class="submit show_author_answer_form"><input type="submit" value="answer"/></p>');
      
      $(this).prev('.submit').find('input[type=submit]').click(function () {
        $(this).parent().next('.author_answer_form').fadeIn();
        $(this).parent().fadeOut();
        return false;
      });
      
    }).hide();
    
    //if ($('.brief_item_history').length > 0) {
      // $('.brief h2').append('<a href="#" class="expand_brief">expand / collapse all</a>').find('a.expand_brief').click(function () { 
      //         $('.brief_item_history').toggle('400');
      //         
      //        print_mode = 1;
      //         
      //         if ($('.brief_item_history').hasClass('hidden')) {
      //           $('.brief_item_history').removeClass('hidden');
      //         } else {
      //           print_mode = 2;
      //           $('.brief_item_history').addClass('hidden');
      //         }
      //         
      //         print_url = $('.print_brief').attr('href').replace(/print_mode=\d/, ('print_mode=' + print_mode));        
      //         $('.print_brief').attr('href', print_url);
      //         
      //}).click();
    //}
    
    // DISCUSS
    
    $('.ask_question').each(function () {
      
      $(this).find('.question_body').each(function () {
        $(this).mouseover(function () { $(this).addClass('active'); });
        $(this).mouseout(function () { $(this).removeClass('active'); });

        $(this).after('<a href="#" class="ask_question_btn">ask question</a>');
        
        $(this).next('a.ask_question_btn').click(function () {
          $(this).toggle();
          $(this).prev('.question_body').toggle();
          return false;
        });

        $(this).find('textarea').blur(function () {
          if (!$(this).parent().hasClass('active')) {
            $(this).parents().filter('.question_body').toggle().next('a.ask_question_btn').toggle();
          }
        });

      }).hide();
      
    });
    
    // $('.brief_item_filter').each(function () {
    //   $(this).find('select').change(function () { 
    //     $(this).parent().submit();
    //   });
    //   $(this).find('input[type=submit]').hide();
    // });
    // 
    $('p.submit').corners();
    
    $('a[rel*=facebox]').each(function () { $(this).attr("href", $(this).attr("href") + ".js"); }).facebox(
      {loadingImage: '/images/fb/loading.gif' , closeImage: '/images/fb/closelabel.gif'}
    );
    
    $('a[rel*=img_facebox]').facebox();
    
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
    
    $('.feedback_form').feedback_form();
    
    $('.edit_brief .brief_item').edit_brief_item();
    
    $('a[href=#beta_feedback]').click(function () {
      $('.feedback_form').find('.wrap').fadeIn();
    })
    
    $('#proposal_long_description').wysiwyg();
    
    $('.activity_stream').fold_activity_stream();
    
    $('.remove_item').delete_item('.remove_item');
    
    $('.remove_with_js').hide();  
    
});

