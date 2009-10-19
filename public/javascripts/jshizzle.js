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

$.fn.triggerFaceboxOnloadEvents = function () {
  
}

////
// $('element').scrollTo()
// $('element').scrollTo(speed)
$.fn.scrollTo = function(speed) {
  var offset = $(this).offset().top - 30
  $('html,body').animate({scrollTop: offset}, speed || 1000)
  return this
}

////
// $('element').spin()
$.fn.spin = function(append) {
  if (append)
    $(this).append('<img src="/images/spinner.gif" class="spinner" />')
  else
    $(this).after('<img src="/images/spinner.gif" class="spinner" />')
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

$.fn.update_collab_list = function (data) {
  
  error_messages = []
  
  jQuery.each(data.brief.errors, function () {
    error_messages.push("<li><p>" + this[1] + "</p></li>");
  });
  
  $('ul.error_messages').html(error_messages.join("\n")).flashNotice();
  
  $('.collaborators tr.user_brief').hide();
  jQuery.each(data.brief.user_briefs, function () { 
    user_brief = this;
        
    $("#user_brief_"+ this.id).show().each(function () {
      
      $(this).find('input[type=checkbox].remove_item').attr('checked', false);
      
      $(this).find('.trash').show();
      
      $(this).find('.spinner').remove();      
      
      if (data.brief.approver_id == user_brief.user_id) {
        $(this).find('input[type=checkbox].approver').attr('checked', true);
      }
      
      $(this).find('input[type=checkbox].author').attr('checked', user_brief.author);
    });
  });
}

$.fn.delete_item = function (remove_item_class) {
  $(this).after('<a href="#" class="trash">Remove</a>');
  
  $(this).next('.trash').click(function () {
    $(this).prev('input[type=checkbox].remove_item').attr('checked', true);
    
    //disable this action
    $(this).hide().spin();
    
    $.put(
      $(this).parents().filter('form').attr('action'), 
      $(this).parents().filter('form').serialize(), 
      $.fn.update_collab_list, 
      'json'
    );
    
    return false;
  });
  
  $(this).hide();
}

$.fn.document_ready = function() {
  
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
    
    $('.brief_item_history').each(function () {            
      var selected_item = document.URL.split('#')[1];
      
      if ((selected_item == undefined) || $(this).parents().filter('.brief_item').attr('id') != selected_item) {
        $(this).hide();
      }
    });
    
    $('.question .author_answer_form').each(function () { 
       
      $(this).before('<p class="submit show_author_answer_form"><input type="submit" value="respond"/></p>');
      
      $(this).prev('.submit').find('input[type=submit]').click(function () {
        $(this).parent().next('.author_answer_form').fadeIn();
        $(this).parent().fadeOut();
        return false;
      });
      
      $(this).mouseover(function () { $(this).addClass('active'); });
      $(this).mouseout(function () { $(this).removeClass('active'); });

      $(this).find('textarea').blur(function () {
        if (!$(this).parents().filter('.author_answer_form').hasClass('active')) {
          $(this).parents().filter('.author_answer_form').fadeOut().prev('.submit').fadeIn();
        }
      });
      
    }).hide();
    
    $('ul.actions').show();
    
    $('ul.actions li a').click(function () {
      $(this).parents().filter('.brief_item').find(this.className.replace("toggle_", ".")).toggle();  
      return false;
    });
    
    // DISCUSS
    
    $('.ask_question').each(function () {
      
      $(this).mouseover(function () { $(this).addClass('active'); });
      $(this).mouseout(function () { $(this).removeClass('active'); });

      $(this).find('textarea').blur(function () {
        if (!$(this).parents().filter('.ask_question').hasClass('active')) {
          $(this).parents().filter('.ask_question').toggle();
        }
      });

    }).hide();
    
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
    
    $(document).unbind('afterReveal.facebox');
    $(document).bind('afterReveal.facebox', $.fn.document_ready);
    
}

jQuery(document).ready($.fn.document_ready);

