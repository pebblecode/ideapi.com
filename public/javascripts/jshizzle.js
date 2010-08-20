
/*
* Dynamically add and remove elements from a complex nested form
* Added from http://github.com/timriley/complex-form-examples/
* Added by George Ornbo for template_briefs 07/07/10
*/
$(function() {
  $('form a.add_child').click(function() {
    var assoc   = $(this).attr('data-association');
    var content = $('#' + assoc + '_fields_template').html();
    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();
        
    $(this).parent().before(content.replace(regexp, new_id));    
    return false;
  });
  
  $('form a.remove_child').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).parents('.fields').hide();
    return false;
  });
});








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

////
// jQuery('element').scrollTo()
// jQuery('element').scrollTo(speed)
//jQuery.fn.scrollTo = function(speed) {
//  var offset = jQuery(this).offset().top - 30
//  jQuery('html,body').animate({scrollTop: offset}, speed || 1000)
//  return this
//}

////
// jQuery('element').spin()
jQuery.fn.spin = function(append, spinner) {
  
  if (spinner == undefined) {    
    spinner = "spinner"
  };
  
  if (append)
    jQuery(this).append('<img src="/images/'+spinner+'.gif" class="spinner" />')
  else
    jQuery(this).after('<img src="/images/'+spinner+'.gif" class="spinner" />')
}


jQuery.fn.fadeToggle = function(speed, easing, callback) { 
   return this.animate({opacity: 'toggle'}, speed, easing, callback); 
};

/*
*
* Fades flash notices out after they are shown
*
*/
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
    form.slideToggle('slow');
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
      jQuery(this).parent().hide();

      jQuery(this).parent().prev('h3').prepend('<a class="toggle_brief_edit" href="#'+jQuery(this).attr("id")+'">'+ link_on_state +'</a>');
      jQuery(this).parent().prev('h3').addClass('empty active');
      
      jQuery(this).parent().prev('h3').find('a.toggle_brief_edit').click(function () {
        
        jQuery(this).parent().parent().find('.body').toggle();
        
        if (jQuery(this).text() == link_on_state) {
          jQuery(this).text(link_off_state);
          jQuery(this).parent().removeClass('empty');
          jQuery(this).parent().parent().find('textarea').focus();
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
  // 
  // jQuery('a.toggle_activity_stream').click(function () {
  //   
  //   if (jQuery(this).hasClass('active')) {
  //     jQuery(this).removeClass('active');
  //   } else {
  //     jQuery(this).addClass('active');
  //   };
  //   
  //   jQuery(this).prev().toggle();
  //   
  //   return false;
  // });
}

jQuery.fn.delete_item = function (remove_item_class, action) {
  jQuery(this).after('<a href="#" class="trash">Remove</a>');
  
  jQuery(this).next('.trash').click(function () {
    jQuery(this).prev('input:checkbox.remove_item').attr('checked', true);
    
    //disable this action
    jQuery(this).hide().spin();
    
    action.apply(jQuery(this));
    
    return false;
  });
  
  jQuery(this).hide();
}

jQuery.hideable_cookie_name = function (id) {
  return "_note_" + id; 
}

jQuery.setup_collaboration_widget = function () {
  jQuery('ul.collaborators').collaboration_widget();
}

jQuery.fn.collaboration_widget = function () {
    
  jQuery(this).siblings('.action').hide();
  
  jQuery(this).find('li.collaboration_user.is_author').each(function () {
    jQuery(this).prepend(jQuery(this).prev('input')[0]);
  }).collab_control();
  
  $('.add_collaborators').add_collaborator_widget();
}

jQuery.fn.add_collaborator_widget = function () { 
  
  $(this).hide().before('<a href="#" class="toggle_add_collab">+</a>');  
  
  $(this).prev('a.toggle_add_collab').toggle_add_collab_link($(this));
  
  //set up add collab links
  $(this).find('a.add_collaborator').add_collab_link();
  
  $(this).update_add_collab_widget();
}

jQuery.fn.toggle_add_collab_link = function (object_to_toggle) {
  var on = "+";
  var off = "-";
  
  $(this).click(function () {
    $(this).text(($(this).text() == on) ? off : on);
    object_to_toggle.slideToggle('slow');
  });
}

jQuery.fn.update_add_collab_widget = function () {
  if (jQuery(this).find('li').size() == 0) {
    $(this).prev('a.toggle_add_collab').hide();
  } else {
    $(this).prev('a.toggle_add_collab').show();
  }
}

jQuery.fn.add_collab_link = function () {
  jQuery(this).attr('href', '#').click(function () {
    $(this).find('input').attr('checked', true);
    $(this).parents().filter('form').submit();
    $(this).fadeOut();
    return false;
  }).find('input').hide();
}

jQuery.fn.update_collab_link = function () {
  
  jQuery(this).parents('ul').find('li input:checkbox, li input:radio').each(function () {        
    jQuery(this).next('a').toggleClass( "selected", jQuery(this).attr('checked') );
  });
  
  return jQuery(this);
  
};

jQuery.fn.fire_collab_action = function (action_type) {
  
  var _link = jQuery(this);
  
  _link.hide().spin(false, 'spinner_e1');
  
  jQuery.put(
    jQuery(this).parents().filter('form').attr('action') + '.js', 
    jQuery(this).parents().filter('li.collaboration_user').find('input').serialize(), 
    (function (data) {
      _link.fadeIn().next('.spinner').remove();
      
      console.log(data);
      
      if (action_type == "remove") {
        _link.parents().filter('li.collaboration_user').fadeOut(500,  function () { $(this).remove(); $('ul.add_collaborators').append(data); $('ul.add_collaborators li:last').hide().fadeIn(); $('.add_collaborators li:last a.add_collaborator').add_collab_link(); $('.add_collaborators').update_add_collab_widget(); });
        
      };
    }),
    'js'
  );
  
  return jQuery(this);

};


jQuery.fn.collab_control = function () {
  
  jQuery(this).find('li').addClass('with_js').find('span').wrap('<a href="#" class="collab_action"></a>');
    
  jQuery(this).find('a.collab_action').click(function () {
    
    var action_type = $(this).prev('input:radio, input:checkbox').collab_action_type();
    
    var can_toggle_radio = !jQuery(this).prev('input:radio').attr('checked');
    
    var author_is_protected = true;
    
    var can_remove = true;
    
    if (action_type == "author") {
      author_is_protected = !(jQuery(this).prev('input:checkbox').attr('checked') && (jQuery(this).parents().find('li.author input:checkbox[checked=true]').length == 1));
    };
        
    if (action_type == "remove") {
      can_remove = !(jQuery(this).parents().filter('ul.options').find('li.author input:checkbox').attr('checked') && (jQuery(this).parents().find('li.author input:checkbox[checked=true]').length == 1));
    }
            
    if (can_toggle_radio && author_is_protected && can_remove) {
      jQuery(this).prev('input:radio, input:checkbox').attr('checked', !jQuery(this).prev('input:radio, input:checkbox').attr('checked'));        
  
      jQuery(this).update_collab_link().fire_collab_action(
        $(this).prev('input:radio, input:checkbox').collab_action_type()
      );
    };
    
    return false;
    
  }).update_collab_link();
  
  jQuery('ul.options').hide();
  jQuery(this).find('p').after('<a href="#" class="options_toggle">options</a>');    
  jQuery(this).find('a.options_toggle').click(function () { jQuery(this).parent().find('ul.options').slideToggle('slow'); return false; });

}

jQuery.fn.collab_action_type = function () {
  return String($(this).attr('className').match(/author|remove|approver/));
}

jQuery.fn.document_ready = function() {
  
    jQuery(".notice, .error").flashNotice();  
    
    jQuery('.help_message').hide();
    
    jQuery('.brief_item textarea').trigger_help_message('.brief_item');
    
    jQuery('.note').hideable_note();

    jQuery(".brief_timeline li span").corners();  

    jQuery('.speech').append('<span class="bubble"></span>');
    
    jQuery('.revision h5').corners();
    
    jQuery('.revision h5').click(function () {
      jQuery(this).siblings('p.changes').toggle();
    }).siblings('p.changes').toggle();
    
    jQuery('.ask_question').each(function () {            
      var selected_item = document.URL.split('#')[1];
      var parent_item = $(this).parents().filter('.brief_item');
      if (parent_item.attr('id') == selected_item){
        parent_item.children().filter('ul.actions').find('a').parent().toggleClass('selected');
        $(this).show();
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

    jQuery('ul.actions li a').live("click", function(){
      jQuery(this).parent("li").toggleClass("selected");
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

    });
    
    
    jQuery.facebox.settings.closeImage = '/images/fb/closelabel.gif';
    jQuery.facebox.settings.loadingImage = '/images/fb/loading.gif';

    jQuery('a[rel*=facebox]').each(function () { jQuery(this).attr("href", jQuery(this).attr("href") + ".js"); }).facebox();
    
    jQuery('a[rel*=img_fb]').each(function () { jQuery(this).attr("href", jQuery(this).attr("href").split('?')[0]) }).facebox();
    
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
        
    jQuery('.activity_stream').fold_activity_stream();
    
    jQuery(document).unbind('afterReveal.facebox');
    jQuery(document).bind('afterReveal.facebox', jQuery.fn.document_ready_extras);
    
    jQuery('a.just_to_question').click(function () {
      jQuery("#" + jQuery(this).attr('href').split('#')[1]).find('.brief_item_history').show();
    });

    // $('#proposal_long_description').wysiwyg({ css: '/stylesheets/wysiwyg_body.css' });
    
    if (document.URL.split('#')[1] != "") {
      //jQuery("#" + document.URL.split('#')[1]).scrollTo();
    }
    
    jQuery('#brief_reference h3').wrap('<a href="#"></a>').click(function () {
      $(this).parent().next('div').toggle('fast');
      $(this).toggleClass('active');
      return false;
    }).addClass('js').parent().next('div').hide();
    
    // jQuery('.edit_proposal .remove_item').delete_item('.remove_item', function () { 
    // 
    //     //move the id input inside of the .proposal_asset
    //     jQuery(this).parents().filter('.proposal_asset').append(jQuery(this).parents().filter('.proposal_asset').prev('input'));
    // 
    //     var proposal_asset = jQuery(this).parents().filter('.proposal_asset');
    // 
    //     jQuery.put(
    //       jQuery(this).parents().filter('form').attr('action'), 
    //       jQuery(this).parents().filter('.proposal_asset').wrap('<form class="remove_asset_form"></form>').parents().filter('form.remove_asset_form').serialize(), 
    //       function () { proposal_asset.remove() }, 
    //       'json'
    //     );
    //   }
    // );
    
    
    jQuery('#textile-help-box a.help-toggle').click(function(){
      jQuery('#textile-help-box .contents').slideToggle('slow');
      if(jQuery(this).text() == '+'){
        jQuery(this).text('-');
      }else{
        jQuery(this).text('+');
      }
      
      return false;
    });
    
    jQuery('form div.change-state input').hover(function(){
      jQuery('form div.change-state p.info').fadeIn('slow');
    },  function(){
        setTimeout(function(){
          jQuery('form div.change-state p.info').fadeOut('slow');
        }, 500);
        
      });
    
    /*
    * Makes template questions sortable
    * See http://docs.jquery.com/UI/Sortable
    */ 
    $('#sortable').sortable({update: function() {
      $.post('/template_briefs/sort', '_method=put&authenticity_token='+AUTH_TOKEN+'&'+$(this).sortable('serialize'));
      }
    });

    /*
    * Shows and hides items when creating template briefs
    * When an item is marked as a heading this hides fields that are not relevant
    */ 
    $('.is-heading').live('click', function(){
      $(this).parent().siblings('.help-message, .optional').slideToggle('slow');
    }); 

    /*
    * We don't want fields to show on the edit view so hide them
    */
    $('.is-heading:checked').parent().siblings('.help-message, .optional').hide();
 
    /*
    * Makes an autocomplete tag list 
    * Also preloads the autocomplete JSON for the dropdown
    * http://wayofspark.com/projects/smarttextbox/
    * 
    */
    $('#brief_tag_field').smartTextBox({autocompleteUrl : "/tags.json", separator : "," });

    jQuery.setup_collaboration_widget();
      
    jQuery.fn.document_ready_extras();
    
}

jQuery.fn.document_ready_extras = function () {
  
  jQuery('.remove_with_js').hide();
  
  
  $('a.remote-delete-answer').click(function(){
    
    var answer = confirm("Are you sure you want to delete this answer?");
    if(answer){
      $(this).append('<img src="/images/spinner.gif" alt="Deleting..." />');
      // we're actually updating the question object, setting the answer and answered_by to null
      $.ajax({
        async: false,
        url: this.href,
        type: "put",
        data: { _method: 'update', "question[author_answer]": "" }, 
        dataType: 'script',
        success: hide_element($(this).parents('div.author_answer').filter(':first'))
      });
    }
    return false;
  });
  
  
  $('a.remote-delete').click(function(){
    var answer = confirm("Are you sure you want to delete this comment?");
    if(answer){
      $(this).append('<img src="/images/spinner.gif" alt="Deleting..." />');
    
      $.ajax({
        async: false,
        url: this.href,
        type: "delete", 
        dataType: 'script',
        success: hide_element($(this).parents('li').filter(':first')),
        error: null
      });
    }
    return false;
  });
  
  
  $('#content div.title a.show-options-menu').click(function(){
    $(this).toggleClass('selected');
    toggle_brief_options_menu($(this).hasClass('selected'));
    return false;
  });
  
  $('#options-menu').hide();
}

jQuery(document).ready(jQuery.fn.document_ready);

function toggle_brief_options_menu(selected){
  options_menu = $('#options-menu');
  if(selected == true){
    options_menu.fadeIn('fast');
  } else {
    options_menu.hide();
  }
  
}
function hide_element(element){
  element.fadeOut('slow', function(){
    element.remove();
  });
}
