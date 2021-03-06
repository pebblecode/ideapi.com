
/*
* Dynamically add and remove elements from a complex nested form
* Added from http://github.com/timriley/complex-form-examples/
* Added by George Ornbo for template_documents 07/07/10
*/
$(function() {
  $('form a.add_child').live('click', function() {
    var assoc   = $(this).attr('data-association');
    var content = $('#' + assoc + '_fields_template').html();
    var regexp  = new RegExp('new_' + assoc, 'g');
    var new_id  = new Date().getTime();
        
    $(this).parents().filter('.actions').before(content.replace(regexp, new_id));    
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



function url_valid_string(string) {
  
  for (var i=0, output='', valid="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_"; i<string.length; i++){
    if (valid.indexOf(string.charAt(i)) != -1){
       output += string.charAt(i);
     }
  }
    
    return output;
} 


jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript");}
});


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


jQuery.fn.spin = function(append, spinner) {
  
  if (spinner == undefined) {    
    spinner = "spinner";
  };
  
  if (append){
    jQuery(this).append('<img src="/images/'+spinner+'.gif" class="spinner" />');
  } else{
    jQuery(this).after('<img src="/images/'+spinner+'.gif" class="spinner" />');}
};


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
};

jQuery.fn.showNotice = function (message) {	 
	jQuery(this).html("<p class='notice'>"+message+"</p>");
	jQuery(".notice", this).flashNotice();
};

jQuery.fn.feedback_form = function () {
  form = jQuery(this).find('.wrap');
  
  jQuery(this).find('.title a.toggle').click(function () {
    form.slideToggle('slow');
  });
  
  form.hide();
};


jQuery.fn.trigger_help_message = function (parent_class) {
  jQuery(this).focus(function () {
    jQuery(this).parents().filter(parent_class).find('.help_message').fadeIn();
  }).blur(function () {
    jQuery(this).parents().filter(parent_class).find('.help_message').fadeOut();
  });
};

jQuery.hideable_cookie_name = function (id) {
  return "_note_" + id; 
};

jQuery.fn.hideable_note = function () {
  var el_id = jQuery(this).attr('id');
  
  if ( !((el_id == "") || (el_id == undefined)) ) {
    if (jQuery.cookie(jQuery.hideable_cookie_name(el_id)) != null) {
      jQuery(this).hide();
    }
  };
  
  jQuery(this).append('<a href="#" class="hide_message">hide</a>').find('a.hide_message').click(function () {
    
    if (jQuery(this).parent().attr('id') != "") {      
      jQuery.cookie(jQuery.hideable_cookie_name(jQuery(this).parent().attr('id')), 'hidden');        
    };
          
    jQuery(this).parent().fadeOut(); 
  
    return false; 
  
  });
};


jQuery.fn.edit_document_item = function () {
  
  var link_on_state = "+";
  var link_off_state = "-";
  
  jQuery(this).find('textarea').each( function () { 
    
    if (jQuery(this).val() == "") {
      jQuery(this).parent().hide();

      jQuery(this).parent().prev('h3').prepend('<a class="toggle_document_edit" href="#'+jQuery(this).attr("id")+'">'+ link_on_state +'</a>');
      jQuery(this).parent().prev('h3').addClass('empty active');
      
      jQuery(this).parent().prev('h3').find('a.toggle_document_edit').click(function () {
        
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
          jQuery(this).find('a.toggle_document_edit').click();
          jQuery(this).css("cursor", "pointer");
        } else {
          jQuery(this).css("cursor", "auto");
        }
      });
      
    };
    
    jQuery(this).change(function () {
      if (jQuery(this).val() != "") {
        jQuery(this).parent().prev('h3').find('a.toggle_document_edit').hide();
        jQuery(this).parent().prev('h3').removeClass('active');
      } else {
        jQuery(this).parent().prev('h3').find('a.toggle_document_edit').show();       
        jQuery(this).parent().prev('h3').addClass('active');
      }
    });
  
  });
};

jQuery.fn.fold_activity_stream = function () {
  jQuery(this).hide();
};

jQuery.fn.delete_item = function (remove_item_class, action) {
  jQuery(this).after('<a href="#" class="trash">Remove</a>');
  
  jQuery(this).next('.trash').live('click', function () {
    jQuery(this).prev('input:checkbox.remove_item').attr('checked', true);
    
    //disable this action
    jQuery(this).hide().spin();
    
    action.apply(jQuery(this));
    
    return false;
  });
  
  jQuery(this).hide();
};

jQuery.hideable_cookie_name = function (id) {
  return "_note_" + id; 
};

jQuery.setup_collaboration_widget = function () {
  jQuery('ul.collaborators').collaboration_widget();
};

jQuery.fn.collaboration_widget = function () {
    
  jQuery(this).siblings('.action').hide();
  
  jQuery(this).find('li.collaboration_user.is_author').each(function () {
    // The following code was not working, so it has been replaced. The generated HTML (by rails) is invalid (input element in a <ul> but outside an <li>)
    // So each browser tries to fix this, which causes inconsistent markup in some browsers (IE7 in particular cannot target those elements properly).
    // Not sure if this IE7's Javascript/DOM misbehaving, or just due to the bad markup. 
   // jQuery(this).append(jQuery(this).prev('input')[0]);
   //$(this).prepend($(this).prev('input'))
   
   // Now, we are creating helper_elements (hidden input fields) with the ID we need to target, 
   // so we can use that to collect the correct element from the DOM... wherever it has been placed. 
   var helper_element = $(this).find('.user_document_id_helper');
   var input_element = $('ul.collaborators input[name*="[id]"][value=' + helper_element.val() + ']');
   $(this).find('.user_document_id_helper').after(input_element);
  }).collab_control();
  
  $('.add_collaborators').add_collaborator_widget();
};

jQuery.fn.add_collaborator_widget = function () { 
  
  $(this).before('<a href="#" class="toggle_add_collab">+</a>');  
  $(this).hide();
  $(this).prev('a.toggle_add_collab').toggle_add_collab_link($(this));
  
  //set up add collab links
  $(this).find('a.add_collaborator').add_collab_link();
  
  $(this).update_add_collab_widget();
};

jQuery.fn.toggle_add_collab_link = function (object_to_toggle) {
  var on = "+";
  var off = "-";
  
  $(this).click(function () {
    $(this).text(($(this).text() == on) ? off : on);
    $(this).toggleClass('active');
    object_to_toggle.toggle('blind',{},300);
  });
};

jQuery.fn.update_add_collab_widget = function () {
};

jQuery.fn.add_collab_link = function () {
  jQuery(this).attr('href', '#').click(function () {
    $(this).find('input').attr('checked', true);
    $(this).fadeOut();
    $(this).parents().filter('ul.add_collaborators').find('li.collaboration_user a.add_collaborator').fadeOut();
    $(this).parents().filter('form').submit();
    
    return false;
  }).find('input').hide();
};

jQuery.fn.update_collab_link = function () {
  
  jQuery(this).parents('ul').find('li input:checkbox, li input:radio').each(function () {        
    jQuery(this).next('a').toggleClass( "selected", jQuery(this).attr('checked') );
  });
  
  return jQuery(this);
  
};

jQuery.fn.fire_collab_action = function (action_type) {
  
  var _link = jQuery(this);
  var _list = $(this).parents('ul.collaborators');
  _link.hide().spin(false, 'spinner_e1');
  var _date = new Date();
  var serialized_data = jQuery(this).parents('li.collaboration_user').find('input').serialize().replace(/%5B/g, '[').replace(/%5D/g, ']');
  
  $.ajax({
    type: 'PUT',
    url: jQuery(this).parents().filter('form').attr('action'),
    data: serialized_data,
    success: function(response){
      $.each(response.document.user_documents, function(index, value){
        var target_span = _list.find('li.collaboration_user input[name="document[user_documents_attributes]['+ index +'][id]"][value="'+ value.id +'"]').parent().find('span.user_role');
        target_span.html(value.document_role.label);
      });
      _link.fadeIn().next('.spinner').remove();
      if (action_type == "remove") {
        _link.parents().filter('li.collaboration_user').fadeOut(500,  function (){
          $(this).remove(); $('ul.add_collaborators').append(response); 
          $('ul.add_collaborators li:last').hide().fadeIn(); 
          $('.add_collaborators li:last a.add_collaborator').add_collab_link(); 
          $('.add_collaborators').update_add_collab_widget(); 
        });
      }
    },
    beforeSend: function(x) {
      if(x && x.overrideMimeType) {
        x.overrideMimeType("application/j-son;charset=UTF-8");
      }
    },
    dataType: "json",
    cache: false
  });
  
  return jQuery(this);

};


jQuery.fn.collab_control = function () {
  
  jQuery(this).find('li').addClass('with_js').find('span').wrap('<a href="#" class="collab_action"></a>');
    
  jQuery(this).find('a.collab_action2').click(function () {
    
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
      
      jQuery(this).update_collab_link().fire_collab_action($(this).prev('input:radio, input:checkbox').collab_action_type());
    };
    
    return false;
    
  }).update_collab_link();
  
  jQuery('ul.options').hide();
  jQuery(this).find('p').after('<a href="#" class="options_toggle">options</a>');    
  jQuery(this).find('a.options_toggle').click(function () { jQuery(this).parent().find('ul.options').slideToggle('slow'); return false; });

};

jQuery.fn.collab_action_type = function () {
  return String($(this).attr('className').match(/author|remove|approver/));
};

jQuery.fn.document_ready = function() {
    

    $("#signup #account_name").keyup(function(key){
      field = $("#account_domain");
      field.attr('value', url_valid_string($(this).val()).toLowerCase());
    });
    
    jQuery(".notice, .error").flashNotice();  
    
    jQuery('.help_message').hide();
    
    jQuery('.document_item textarea').trigger_help_message('.document_item');
    
    jQuery('.note').hideable_note();
    jQuery('.speech').append('<span class="bubble"></span>');
    
    
    jQuery('.document_item_activity').hide();
    jQuery('.document_item_activity').each(function () {            
      var selected_item = document.URL.split('#')[1];
      var parent_item = $(this).parents().filter('.document_item');
      if (parent_item.attr('id') == selected_item){
        parent_item.children().filter('ul.actions').find('a').parent().toggleClass('selected');
        $(this).show();
      }
    });
    
    $('#documents li.revision .toggle_revision_body').live('click',function(){
      $(this).parents().filter('.revision-body').find('.body').toggle();
      return false;
    });
    
        
    // jQuery('.question .author_answer_form').each(function () { 
    //        
    //       jQuery(this).before('<div class="submit show_author_answer_form"><input type="submit" value="respond"/></div>');
    //       
    //       jQuery(this).prev('.submit').find('input[type=submit]').click(function () {
    //         jQuery(this).parent().next('.author_answer_form').fadeIn();
    //         jQuery(this).fadeOut();
    //         return false;
    //       });
    //       
    //       jQuery(this).mouseover(function () { jQuery(this).addClass('active'); });
    //       jQuery(this).mouseout(function () { jQuery(this).removeClass('active'); });
    // 
    //       jQuery(this).find('textarea').blur(function () {
    //         if (!jQuery(this).parents().filter('.author_answer_form').hasClass('active')) {
    //           jQuery(this).parents().filter('.author_answer_form').fadeOut().prev('.submit').fadeIn();
    //         }
    //       });
    //       
    //     }).hide();

    jQuery('ul.actions li a').live("click", function(){
      jQuery(this).parent("li").toggleClass("selected");
      var container = jQuery(this).parents().filter('.document_item').find(this.className.replace("toggle_", "."));
      if(jQuery(this).parent("li").hasClass('selected')){
        container.toggle('blind', {}, 500);
      } else { container.toggle('blind', {}, 500);}
      
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
    
    jQuery('a[rel*=img_fb]').each(function () { jQuery(this).attr("href", jQuery(this).attr("href").split('?')[0]); }).facebox();
    
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
    
    jQuery('.edit_document .document_item').edit_document_item();
    
    jQuery('a[href=#beta_feedback]').click(function () {
      jQuery('.feedback_form').find('.wrap').fadeIn();
    });
        
    jQuery('.activity_stream').fold_activity_stream();
    
    jQuery(document).unbind('afterReveal.facebox');
    jQuery(document).bind('afterReveal.facebox', jQuery.fn.document_ready_extras);
    
    jQuery('a.just_to_question').click(function () {
      jQuery("#" + jQuery(this).attr('href').split('#')[1]).find('.document_item_history').show();
    });

    
    if (document.URL.split('#')[1] != "") {
      //jQuery("#" + document.URL.split('#')[1]).scrollTo();
    }
    
    jQuery('#document_reference h3').wrap('<a href="#"></a>').click(function () {
      $(this).parent().next('div').toggle();
      $(this).toggleClass('active');
      return false;
    }).addClass('js').parent().next('div').hide();
    
    jQuery('#textile-help-box a.help-toggle').click(function(){
      jQuery('#textile-help-box .contents').toggle();
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
      $.post('/template_documents/sort', '_method=put&authenticity_token='+AUTH_TOKEN+'&'+$(this).sortable('serialize'));
      }
    });
    /*
    * Shows and hides items when creating template documents
    * When an item is marked as a heading this hides fields that are not relevant
    */ 
    $('#template_documents .is-heading').live('click', function(){
      $(this).parents('.fields').find('.help-message, .optional').slideToggle('slow');
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
    $('#document_tag_field').smartTextBox({autocompleteUrl : "/tags.json", separator : ",", placeholder: "Type the name of a tag you'd like to use. Use commas to separate multiple tags.", autocomplete : true });

    /*
    * Hides checkboxes on add user form on User#show
    */
    $('table#document-privileges td.document-title input').parent().siblings().children().hide();

    /*
    * Show any checkboxes that are checked on page load (form errors etc)
    */
    $('table#document-privileges td.document-title input:checked').parent().siblings().children().show();

    /*
    * Toggle show and hide of author & approver links
    */
    $('table#document-privileges td.document-title input[type=checkbox]').click (function (){
      if ($(this).is (':checked')){
          $(this).parent().siblings().children().fadeIn();
        }
      else{
          $(this).parent().siblings().children().fadeOut();
        }
      });
    
    jQuery.setup_collaboration_widget();
      
    jQuery.fn.document_ready_extras();
    
};

jQuery.fn.document_ready_extras = function () {
  
  jQuery('.remove_with_js').hide();
  jQuery('.show_with_js').show();
  
  
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
  
  
  $('a.remote-delete').live('click', function(){
    var answer = confirm("Are you sure you want to delete this comment?");
    if(answer){
      $(this).append('<img src="/images/spinner.gif" alt="Deleting..." />');
    
      $.ajax({
        async: false,
        url: this.href,
        type: "delete", 
        dataType: 'script',
        success: hide_element($(this).parents('li')),
        error: null
      });
    }
    return false;
  });
  
  $('#content a.show-options-menu').live('click', function(){
    $(this).toggleClass('active');
    toggle_document_options_menu();
    return false;
  });
  
  $('#document-tags').hide();
  
  $('#document-tags-toggle').click(function(){
    $('#document-tags').toggle();
    $(this).toggleClass('selected');
    return false;
  });
  
};

jQuery(document).ready(jQuery.fn.document_ready);

function toggle_document_options_menu(selected){
  $('#options-menu').toggle('blind', {}, 400);
}

function hide_element(element){
  element.slideUp('slow');
}

$(document).ready(function(){
  $('#idea-attachments a.js-toggle-edit').live('click', function(){
    $(this).parent().find('.description-text').toggle();
    $(this).parents('.proposal_asset').find('.description-textarea').toggle();
    return false;
  });
  
  
  
  
  // Override delete, etc in actions bar. 
  $('#options-menu li form a').live('click', function(){
    var answer = confirm("Are you sure?");
    if(answer){
      $(this).parent().submit();
    }
    return false;
  });
  
  // Proposals. Maybe we should start putting things in a better arrangement...
  
  $('#update_proposal_status #proposal_submit').click(function(){
    if($('#proposal_state').val() === ''){
      alert("You must select a status");
      return false;
    }
    var submit_button = $(this);
    var form = $(this).parents('form');
    var loading_gif = $(this).siblings('.ajax-loading');
    
    // show loading gif, disable button (in case they click twice!)
    loading_gif.show();
    submit_button.attr('disabled', 'disabled');
    
    $.ajax({
      type: 'POST',
      url: form.attr('action'),
      data: form.serialize(),
      complete: function(){
        loading_gif.hide();
        submit_button.attr('disabled', false);
      },
      error: function(data){

      },
      success: function(response){
        state = response.proposal.state.replace('_',' ');
        $('#widget_proposal_status').html(state);
      },
      dataType: "json",
      cache: false
    });
    return false;
  });
  
  
  /*
    Proposals edit/new submit form. When submitted, 
    place an overlay on top of every new asset div with a loading.gif, 
    to indicate progress.
    OR: Simply add the loading.gif arrows at the side of the button. 
  */
    $('#proposals div.col_1 form').submit(function(){
      $(this).find('p.submit').prepend('<img src="/images/ui/loading.gif" alt="Loading..." />');
    });
  
  
  /*
    Inline labels
    Show them when forms are loaded and certain conditions are met.
    For now, just used in proposals forms
  */
  $('#proposals form .title-span label').inFieldLabels();
  $('#proposals .field label').inFieldLabels();
  $('#template_documents .infield-label').inFieldLabels();
  
  $('#proposals #idea-attachments .proposal_asset .close-box').live('click',function(){
    var parent_box = $(this).parents('div.new.proposal_asset');
    parent_box.fadeOut('fast', function(){
      parent_box.remove();
    });
    return false;
  });
  
  /* Ideas in brief show view - hide toggle */
  
  $('.sb-trigger').live('click', function(){
    $(this).closest('.sb-group').children('.sb-content').toggle();
  });
  
});

