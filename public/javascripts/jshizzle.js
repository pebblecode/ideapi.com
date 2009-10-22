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

jQuery.fn.triggerFaceboxOnloadEvents = function () {
  
}

////
// jQuery('element').scrollTo()
// jQuery('element').scrollTo(speed)
jQuery.fn.scrollTo = function(speed) {
  var offset = jQuery(this).offset().top - 30
  jQuery('html,body').animate({scrollTop: offset}, speed || 1000)
  return this
}

////
// jQuery('element').spin()
jQuery.fn.spin = function(append) {
  if (append)
    jQuery(this).append('<img src="/images/spinner.gif" class="spinner" />')
  else
    jQuery(this).after('<img src="/images/spinner.gif" class="spinner" />')
}


jQuery.fn.fadeToggle = function(speed, easing, callback) { 
   return this.animate({opacity: 'toggle'}, speed, easing, callback); 
};

jQuery.fn.flashNotice = function () {
	jQuery(this).hide();
	jQuery(this).fadeIn();
	
	var element = jQuery(this);
	var timeout = setTimeout(function () { element.fadeOut(); }, 3000);
	
	jQuery(this).click(function () {
	  clearTimeout(timeout);
	  jQuery(this).fadeOut();
	});
}

jQuery.fn.showNotice = function (message) {	 
	jQuery(this).html("<p class='notice'>"+message+"</p>")
	jQuery(".notice", this).flashNotice();
}

jQuery.fn.feedback_form = function () {
  form = jQuery(this).find('.wrap');
  
  jQuery(this).find('.title a').click(function () {
    form.fadeToggle();
  });
  
  form.hide();
}


jQuery.fn.trigger_help_message = function (parent_class) {
  jQuery(this).focus(function () {
    jQuery(this).parents().filter(parent_class).find('.help_message').fadeIn();
  }).blur(function () {
    jQuery(this).parents().filter(parent_class).find('.help_message').fadeOut();
  });
}

jQuery.hideable_cookie_name = function (id) {
  return "_note_" + id; 
}

jQuery.fn.hideable_note = function () {
  var el_id = jQuery(this).attr('id');
  
  if ( !((el_id == "") || (el_id == undefined)) ) {    
    if (jQuery.cookie(jQuery.hideable_cookie_name(el_id)) != null) {      
      jQuery(this).remove();
    }
  };
  
  jQuery(this).append('<a href="#" class="hide_message">hide</a>').find('a.hide_message').click(function () {
    
    if (jQuery(this).parent().attr('id') != "") {      
      jQuery.cookie(jQuery.hideable_cookie_name(jQuery(this).parent().attr('id')), 'hidden');        
    };
          
    jQuery(this).parent().fadeOut(); 
  
    return false; 
  
  });
}


jQuery.fn.edit_brief_item = function () {
  
  var link_on_state = "+";
  var link_off_state = "-";
  
  jQuery(this).find('textarea').each( function () { 
    
    if (jQuery(this).val() == "") {
      jQuery(this).hide();

      jQuery(this).parent().prev('h3').prepend('<a class="toggle_brief_edit" href="#'+jQuery(this).attr("id")+'">'+ link_on_state +'</a>');
      jQuery(this).parent().prev('h3').addClass('empty active');
      
      jQuery(this).parent().prev('h3').find('a.toggle_brief_edit').click(function () {
        
        jQuery(this).parent().parent().find('textarea').toggle();
        
        if (jQuery(this).text() == link_on_state) {
          jQuery(this).text(link_off_state);
          jQuery(this).parent().removeClass('empty');
        } else {
          jQuery(this).text(link_on_state);
          jQuery(this).parent().addClass('empty');
        };
        
        return false;
        
      });
      
      jQuery(this).parent().prev('h3').each(function () { jQuery(this).css("cursor", "pointer"); }).click(function () {
        if (jQuery(this).hasClass('active')) {
          jQuery(this).find('a.toggle_brief_edit').click();
          jQuery(this).css("cursor", "pointer");
        } else {
          jQuery(this).css("cursor", "auto");
        }
      });
      
      //.click( function () { jQuery(this).next('textarea').show(); } );
    };
    
    jQuery(this).change(function () {
      if (jQuery(this).val() != "") {
        jQuery(this).parent().prev('h3').find('a.toggle_brief_edit').hide();
        jQuery(this).parent().prev('h3').removeClass('active');
      } else {
        jQuery(this).parent().prev('h3').find('a.toggle_brief_edit').show();       
        jQuery(this).parent().prev('h3').addClass('active');
      }
    });
  
  });
}

jQuery.fn.fold_activity_stream = function () {
  jQuery(this).hide();
  
  jQuery('a.toggle_activity_stream').click(function () {
    
    if (jQuery(this).hasClass('active')) {
      jQuery(this).removeClass('active');
    } else {
      jQuery(this).addClass('active');
    };
    
    jQuery(this).prev().toggle();
    
    return false;
  });
}

jQuery.fn.update_collab_list = function (data) {
  
  error_messages = []
  
  jQuery.each(data.brief.json_errors, function () {
    error_messages.push("<li><p>" + this + "</p></li>");
  });
  
  jQuery('ul.error_messages').html(error_messages.join("\n")).flashNotice();
  
  jQuery('.collaborators tr.user_brief').hide();
  
  jQuery.each(data.brief.user_briefs, function () { 
    user_brief = this;
        
    jQuery("#user_brief_"+ this.id).show().each(function () {
      
      jQuery(this).find('input[type=checkbox].remove_item').attr('checked', false);
      
      jQuery(this).find('.trash').show();
      
      jQuery(this).find('.spinner').remove();      
      
      if (data.brief.approver_id == user_brief.user_id) {
        jQuery(this).find('input[type=checkbox].approver').attr('checked', true);
      }
      
      jQuery(this).find('input[type=checkbox].author').attr('checked', user_brief.author);
    });
    
    if (!jQuery("#user_brief_"+ this.id)) {
      //new_el = jQuery('.collaborators tr.user_brief:last').clone();
    }
    
  });
  
  jQuery('form.edit_brief_collaborators input[type=submit]').show();
  jQuery('form.edit_brief_collaborators input[type=submit]').next('.spinner').remove();
}

jQuery.fn.delete_item = function (remove_item_class) {
  jQuery(this).after('<a href="#" class="trash">Remove</a>');
  
  jQuery(this).next('.trash').click(function () {
    jQuery(this).prev('input[type=checkbox].remove_item').attr('checked', true);
    
    //disable this action
    jQuery(this).hide().spin();
    
    jQuery.put(
      jQuery(this).parents().filter('form').attr('action'), 
      jQuery(this).parents().filter('form').serialize(), 
      jQuery.fn.update_collab_list, 
      'json'
    );
    
    return false;
  });
  
  jQuery(this).hide();
}

jQuery.fn.document_ready = function() {
  
    jQuery(".notice, .error").flashNotice();  
    
    jQuery('.help_message').hide();
    
    jQuery('.brief_item textarea').trigger_help_message('.brief_item');
    
    jQuery('.note').hideable_note();

    jQuery(".brief_timeline li span").corners();  

    jQuery('.speech').append('<span class="bubble" />').corners();
    
    jQuery('.revision h5').corners();
    
    jQuery('.revision h5').click(function () {
      jQuery(this).siblings('p.changes').toggle();
    }).siblings('p.changes').toggle();
    
    jQuery('.brief_item_history').each(function () {            
      var selected_item = document.URL.split('#')[1];
      
      if ((selected_item == undefined) || jQuery(this).parents().filter('.brief_item').attr('id') != selected_item) {
        jQuery(this).hide();
      }
    });
    
    jQuery('.question .author_answer_form').each(function () { 
       
      jQuery(this).before('<p class="submit show_author_answer_form"><input type="submit" value="respond"/></p>');
      
      jQuery(this).prev('.submit').find('input[type=submit]').click(function () {
        jQuery(this).parent().next('.author_answer_form').fadeIn();
        jQuery(this).parent().fadeOut();
        return false;
      });
      
      jQuery(this).mouseover(function () { jQuery(this).addClass('active'); });
      jQuery(this).mouseout(function () { jQuery(this).removeClass('active'); });

      jQuery(this).find('textarea').blur(function () {
        if (!jQuery(this).parents().filter('.author_answer_form').hasClass('active')) {
          jQuery(this).parents().filter('.author_answer_form').fadeOut().prev('.submit').fadeIn();
        }
      });
      
    }).hide();
    
    jQuery('ul.actions').show();
    
    jQuery('ul.actions li a').click(function () {
      jQuery(this).parents().filter('.brief_item').find(this.className.replace("toggle_", ".")).toggle();  
      return false;
    });
    
    // DISCUSS
    
    jQuery('.ask_question').each(function () {
      
      jQuery(this).mouseover(function () { jQuery(this).addClass('active'); });
      jQuery(this).mouseout(function () { jQuery(this).removeClass('active'); });

      jQuery(this).find('textarea').blur(function () {
        if (!jQuery(this).parents().filter('.ask_question').hasClass('active')) {
          jQuery(this).parents().filter('.ask_question').toggle();
        }
      });

    }).hide();

    jQuery('a[rel*=facebox]').each(function () { jQuery(this).attr("href", jQuery(this).attr("href") + ".js"); }).facebox(
      {loadingImage: '/images/fb/loading.gif' , closeImage: '/images/fb/closelabel.gif'}
    );
    
    jQuery('a[rel*=img_facebox]').facebox();
    
    jQuery('input, textarea').each(function () {
      if (jQuery(this).attr('title') != "" && jQuery(this).val() == "") {
        
        jQuery(this).val(jQuery(this).attr('title'));
        
        jQuery(this).focus(function () {
          if (jQuery(this).val() == jQuery(this).attr('title')) {
            jQuery(this).addClass('').val('');
          };
        });

        jQuery(this).blur(function () {
          if (jQuery(this).val() == "") {
            jQuery(this).val(jQuery(this).attr('title'));
          }
        });
        
      };
    });
    
    jQuery('.feedback_form').feedback_form();
    
    jQuery('.edit_brief .brief_item').edit_brief_item();
    
    jQuery('a[href=#beta_feedback]').click(function () {
      jQuery('.feedback_form').find('.wrap').fadeIn();
    })
    
    //jQuery('#proposal_long_description')
    
    jQuery('.activity_stream').fold_activity_stream();
    
    jQuery('.remove_item').delete_item('.remove_item');
    
    jQuery('form.edit_brief_collaborators input[type=submit]').click(function () {
      //disable this action
      jQuery(this).hide().spin();

      jQuery.put(
        jQuery(this).parents().filter('form').attr('action'), 
        jQuery(this).parents().filter('form').serialize(), 
        jQuery.fn.update_collab_list, 
        'json'
      );

      return false;
    });
    
    jQuery('.remove_with_js').hide();  
    
    jQuery(document).unbind('afterReveal.facebox');
    jQuery(document).bind('afterReveal.facebox', jQuery.fn.document_ready);
    
    jQuery('a.just_to_question').click(function () {
      jQuery("#" + jQuery(this).attr('href').split('#')[1]).find('.brief_item_history').show();
    });
    
    // /* Handle links inside editable area. */
    // $('.editable > a').bind('click', function() {
    //   $(this).parent().trigger('click');
    //   return false; 
    // });
    // 
    // $('#wysiwyg_1').editable('http://www.appelsiini.net/projects/jeditable/wysiwyg/php/save.php', { 
    //   indicator : '<img src="../img/indicator.gif">',
    //   type      : 'wysiwyg',
    //   width     : 640,
    //   height    : 'auto',
    //   onblur    : 'ignore',
    //   submit    : 'OK',
    //   cancel    : 'Cancel'
    // });

    $('#proposal_long_description').wysiwyg();
    
}

jQuery(document).ready(jQuery.fn.document_ready);


