/*
  Very simple jQuery.ajax function helper.
  Just send the form you want to submit, and the callback functions success and error.
  It will serialize the form data, submit it, and execute the callbacks.
*/

function ajax_submit(form, success, error){
  $.ajax({
    type: 'POST',
    url: form.attr('action'),
    data: form.serialize(),
    error: function(response){
      error(response);
    },
    success: function(response){
      success(response);
    },
    cache: false
    
  });
};
function ajax_submit_json(form, success, error){
  $.ajax({
    type: 'POST',
    url: form.attr('action'),
    data: form.serialize(),
    complete: function(){
    },
    error: function(response){
      error(response);
    },
    success: function(response){
      success(response);
    },
    beforeSend: function(x) {
      if(x && x.overrideMimeType) {
        x.overrideMimeType("application/j-son;charset=UTF-8");
      }
    },
    dataType: "json",
    cache: false
    
  });
};

(function($){
  $.fn.append_bubble = function(){
    this.find('.speech').append('<span class="bubble"></span>');
  };
  
  $.fn.setup_answer_form = function(){
    var _answer_form = this.find('div.author_answer_form');
    if (_answer_form.size() > 0){
      _answer_form.before('<div class="toggle_author_answer_form"><a class="toggle" href="javascript:void(0)">respond</a></div>');
      _answer_form.hide();
      _answer_form.siblings('div.toggle_author_answer_form').find('a.toggle').click(function(){
        _answer_form.fade_toggle();
      });
    }
    return this;
  };
  
  $.fn.fade_out = function(duration, callback){
    if(!duration) duration = 'slow';
    if(!callback) callback = function(){};
    
    if($.browser.msie){
      this.hide();
    }else{
      this.fadeOut(duration, callback);
    }
  };
  $.fn.fade_in = function(duration, callback){
    if(!duration) duration = 'slow';
    if(!callback) callback = function(){};
    
    if($.browser.msie){
      this.show();
    }else{
      this.fadeIn(duration, callback);
    }
  };
  
  $.fn.fade_toggle = function(duration, callback){
    if(!duration) duration = 'fast';
    if(!callback) callback = function(){};

    if($.browser.msie){
      this.toggle();
    }else{
      this.fadeToggle(duration, callback);
    }
  };
  
  
})(jQuery);

jQuery.update_item_history_tabs = function(){
  var _document_items = $('#content div.col_1 div.document_item');
  _document_items.each(function(){
    var _tab = $(this).find('ul.actions a.toggle_document_item_activity');
    var _list = $(this).find('ul.document_item_history');
    var _size = _list.children().size() + _list.find('div.author_answer').size();
    if (_size == 0) _tab.text('discussion');
    else _tab.text('('+ _size +') discussion');    
  });
};

jQuery.update_collaborators = function (){
  var _form, _link = null;
  
  var success = function(data){
    $('#update_collaborators').html(data);
    $.setup_collaboration_widget();
  };
  var error = function(data){
    _form.find('.spinner').hide();
    _link.show();
    alert(data.responseText);
  };
  
  $('#documents ul.add_collaborators form.new_user_document .add_user_document_button').live('click', function(){
    _form = $(this).parents('form');
    _link = $(this);
    // replace ADD button with spinner
    $(this).hide().spin(false, 'ui/loading');

    ajax_submit(_form, success, error);    
    return false;
  });
  
  $('#update_collaborators ul.options a.collab_action').live('click', function(){
    _link = $(this);
    _form = $(this).parents('form');
    _link.hide().spin(false, 'ui/loading');
    ajax_submit(_form, success, error);
    return false;
  });
};

jQuery.ajaxify_comments = function(){
  var _container, _submit, _comment, _form = null;
  
  var success_new = function(data){
    $('#new_comment_li').before(data);
    $("#comment_submit").show();
    $("#new_comment_form .loading-gif").hide();
    $("#comment_comment").val('');
  };
  var success_delete = function(data){
    _container.remove();
  };
  var error_delete = function(data){
    
  };
  
  var error_new = function(data){
    $('#new_comment_li').before(data);
    $("#comment_submit").show();
    $("#new_comment_form .loading-gif").hide();
    $("#comment_comment").val('');
    $('#new_comment_li').find('p.error_message').remove();
    $('#new_comment_form').append('<p class="error_message">' + data.responseText + '</p>');
    $('#new_comment_form').find('p.error_message').hide().flashNotice();
    
  };
  
  $('#comments_area .delete_comment_form input.comment-delete').live('click', function(e){
    _form = $(this).parents('form.delete_comment_form');
    _container = _form.parents('li');
    _submit = $(this);
    _submit.hide().spin(false, 'ui/loading');
    ajax_submit_json(_form, success_delete, error_delete);
    
    e.preventDefault();
    return false;
  });
  
  $('#comment_submit').live('click', function(e){
    
    $("#new_comment_form").find('.loading-gif').show();
    $('#comment_submit').hide();
    ajax_submit($("#new_comment_form"), success_new, error_new);
    e.preventDefault();
    return false;
  });
  
};

jQuery.ajaxify_item_revisions = function(){
  
  var _container, _spinner, _form, _submit = null; 

  var success = function(data){
    // update the count on the tab
    _container.remove();
  };
  var error = function(data){
    alert("Could not delete this item. Please try again or reload the page.");
    _submit.show();
    _spinner.hide();
  };
  
  $('#documents li.revision form.delete-item-revision .delete-item-revision-submit').live('click', function(e){
    _submit = $(this);
    _container = $(this).parents('li.revision');
    _form = $(this).parents('form.delete-item-revision');
    $(this).hide().spin(false, 'ui/loading');
    _spinner = _form.find('.spinner');
    ajax_submit(_form, success, error);
    e.preventDefault();
    return false;
  });
  
};

jQuery.ajaxify_questions_and_answers = function(){
  
  var _current_form, _current_list, _deleted, _cross, _submit, _parent, _form, _spinner = null;
  
  var success_new = function(data){
    
    // there might not be any list, so we would need to create if it doesn't exist yet: 
    if(_current_list.size() == 0){
      _current_form.parents('.question_form').before('<ul class="document_item_history"></ul>');
      _current_list = _current_form.parents('.document_item_activity').find('ul.document_item_history');
    }
    _current_list.append(data).append_bubble();
    _current_form.find('.loading-gif').addClass('hide');
    _current_form.find('.new_question_submit').show();
    _current_form.find('textarea').val('');
    $.update_item_history_tabs();
  };
  var success_delete_question = function(data){
    // if successful, we simply hide then delete the node. this is the easiest.
    _deleted.remove();
    $.update_item_history_tabs();
    
  };
  var error_delete_question = function(data){
    // if error, alert (error occurred while deleting, please try again) and reset the button 
    alert("Sorry, we couldn't delete that question. Please try again. You may need to reload the page.");
    _cross.parent().find('.spinner').remove();
    _cross.show();
  };
  
  var error_new = function(data){
    var _container = _current_form.find('div.speech');
    _container.find('p.error_message').remove();
    _current_form.find('.loading-gif').addClass('hide');
    _current_form.find('.new_question_submit').show();
    _container.append('<p class="error_message">' + data.responseText + '</p>');
    _container.find('p.error_message').hide().flashNotice();
  };
  
  $("#documents form.new_question input.new_question_submit").live('click', function(e){
    _current_form = $(this).parents('form');
    _submit = $(this);
    _current_list = _current_form.parents('.question_form').siblings('ul.document_item_history');
    _submit.hide();
    _current_form.find('img.loading-gif').removeClass('hide');
    ajax_submit(_current_form, success_new, error_new);
    e.preventDefault();
    return false;
  });
  
  $("#documents form.delete_question_form .question-delete").live('click', function(e){
    _current_form = $(this).parents('form');
    _deleted = _current_form.parents('li.question');
    _cross = $(this);
    // bake cakes
    _cross.hide().spin(false, 'ui/loading');
    
    ajax_submit(_current_form, success_delete_question, error_delete_question);
    
    e.preventDefault();
    return false;
  });
  
  
  /*
    answers. tricky part.
    
    all we're concerned about is: 
    - parent <li>, because we're replacing it.
    - current <form>, because we're submitting it
    - submit button (we're disabling it)
    - spinner
  */
  
  var success_answer_new = function(data){
    _parent.replaceWith($(data).setup_answer_form());
    $.update_item_history_tabs();
  };
  var success_answer_delete = function(data){
    // first fade the answer away... 
    _parent.find('div.author_answer').fadeOut(1000, function(){
      // Data comes back with the answer form showing.
      // setup_answer_form() creates a reply link that toggles the visibility
      // of the answer form. 
      _parent.replaceWith($(data).setup_answer_form());
      $.update_item_history_tabs();
    });
  };
  
  var error_answer_new = function(data){
    _form.find('p.button').after('<p class="error_message">'+ data.responseText +'</p>');
    _form.find('p.error_message').hide().flashNotice();
    _form.find('textarea').val('');
    _spinner.hide();
    _submit.show();
    $.update_item_history_tabs();
  };
  var error_answer_delete = function(data){
    
  };
  
  /* New answers */
  $('#documents form.question-answer-form input.submit-question-answer').live('click', function(e){
    _parent = $(this).parents('li.question');
    _form = $(this).parents('form');
    _submit = $(this);
    _submit.hide().spin(false, 'ui/loading');
    _spinner = $(this).find('.spinner');
    ajax_submit(_form, success_answer_new, error_answer_new);
    e.preventDefault();
    return false;
  });
  
  /* Delete answers (update questions) */
  
  $('#documents form.delete-question-answer-form input.close-button').live('click', function(e){
    _parent = $(this).parents('li.question');
    _form = $(this).parents('form');
    _submit = $(this);
    _submit.hide().spin(false, 'ui/loading');
    _spinner = $(this).find('.spinner');
    ajax_submit(_form, success_answer_delete, error_answer_delete);
    e.preventDefault();
    return false;
  });
};

jQuery.user_links_external = function(){
  $('div.body p a').each(function(){
    $(this).attr('target', '_blank');
  });
  $('div.speech p a').each(function(){
    $(this).attr('target', '_blank');
  });
  $('div.comments_area p a').each(function(){
    $(this).attr('target', '_blank');
  });
  $('div.proposal p a').each(function(){
    $(this).attr('target', '_blank');
  });
};


/* Inline editing documents */
(function($){
  $.fn.inline_edit_documents = function(){
    var _document = this.find('div.document');
    
    var _submit, _form, _parent, _spinner = null;
    /* BEGIN Title */
    $('#content-header a.toggle-inline-edit').live('click', function(){
      $('#content-header .show').toggle();
      $(this).parents('.edit').toggle(0, function(){
        $(this).find('input.title').val($('#content-header .show h2').text());
      });
    });
    $('#content-header .editable h2').live('click', function(){
      $('#content-header .show').toggle();
      $('#content-header .edit').toggle();
    });
    // Ajax form submit
    var title_success = function(data){
      _parent.replaceWith(data);
      $('ul.breadcrumbs li:last span').text($(data).find('input.title').val());
    };
    
    var title_error = function(data){
    };
    
    $('#content-header form').live('submit',function(e){
      _form = $(this);
      _submit = $(this).find('input.inline-edit-submit');
      _submit.hide().spin(false, 'ui/loading');
      _spinner = _submit.siblings('.spinner');
      _parent = $('#content-header');
      
      ajax_submit(_form, title_success, title_error);
      
      e.preventDefault();
    });
    
    
    /* END Title */
    
    /* BEGIN Sections */
    
    $.fn.hide_activity = function(){
      this.find('.document_item_activity').hide();
      return this;
    };
    
    var generic_success = function(data){
      _parent.replaceWith($(data).hide_activity());
      
    };
    var generic_error = function(data){
      _submit.show();
      _spinner.remove();
      $(this).siblings('.show').toggle();
      $(this).siblings('.edit').toggle();
    };
    
    $("#documents.show .section a.toggle-inline-edit").live('click', function(e){
      var _parent = $(this).parents('.section');
      // $(this).siblings('div.editable').toggle('slide', {}, 1000);
      _parent.find('div.editable').toggle();
      _parent.find('div.edit').toggleClass('revealed');
      if($(this).text() == 'edit'){ $(this).text('show'); }
      else{ $(this).text('edit'); }
      
      _parent.find('ul.actions').toggleClass('hide');
      _parent.find('div.document_item_activity').toggleClass('hide');
    });

    $("#documents.show .section .edit a.cancel-inline-edit").live('click', function(e){
      var _parent = $(this).parents('.section');
      _parent.find('div.editable').toggle();
      _parent.find('div.edit').toggleClass('revealed');
      var _toggle_link = $(this).parents('div.section').find('a.toggle-inline-edit');
      
      if(_toggle_link.text() == 'edit'){
        _toggle_link.text('show');
      }else{
        _toggle_link.text('edit'); 
      }
      _parent.find('ul.actions').toggleClass('hide');
      _parent.find('div.document_item_activity').toggleClass('hide');
      
      
    });
    
    _document.find('form.inline-edit-form input.inline-edit-submit').live('click', function(e){
      _submit = $(this);
      _submit.hide().spin(false, 'ui/loading');
      _form = $(this).parents('form.inline-edit-form');
      _parent = $(this).parents('div.section');
      _spinner = _submit.siblings('.spinner');
      
      ajax_submit(_form, generic_success, generic_error);
      e.preventDefault();
    });
    /* END Sections */
    
    /* BEGIN delete sections*/
    var generic_delete_success = function(data){
      _parent.fadeOut(100, function(){
        _parent.remove();
      });
    };
    var generic_delete_failure = function(data){
      alert('Error');
    };
    
    $('form.section-delete-form').live('submit', function(e){
      if(!confirm("Are you sure you want to delete this section?")) return false;
      _form = $(this);
      _submit = $(this).find('input.delete-section-submit');
      _submit.hide().spin(false, 'ui/loading');
      _spinner = _submit.siblings('.spinner');
      _parent = $(this).parents('div.document_item');
      
      ajax_submit(_form, generic_delete_success, generic_delete_failure);
      
      e.preventDefault();
      return false;
    });
    /* END delete sections */
    
    /* BEGIN new sections */
    $('#document_item_is_heading').live('click', function(e){
      if($(this).attr('checked') == true){
        $("#new-section-body").parent('.field').hide();
      }else{
        $("#new-section-body").parent('.field').show();
      }
    });
    $('.toggle-add-new-section').live('click', function(e){
      $('#new-section').toggle();
      e.preventDefault();
    });
    var new_section_success = function(data){
      $('#new-section-title').val('');
      $('#new-section-body').val('');
      var _data = $(data);
      _data.hide();
      _data.find(".document_item_activity").hide();
      $('#sortable_document_items').append(_data);
      _data.fadeIn();
      _submit.show();
      _spinner.remove();
    };
    var new_section_error = function(data){
      _submit.show();
      _spinner.remove();
    };
    
    $("#new-section form").live('submit', function(e){
      _form = $(this);      
      _submit = $("#new-section-submit");
      _submit.hide().spin(false, 'ui/loading');
      _spinner = _submit.siblings('.spinner');
      
      ajax_submit(_form, new_section_success, new_section_error);
      e.preventDefault();
    });
    /* END new sections */
    
    /* Reorder sections */
    $('#reorder-sections').live('click', function(){
      if($(this).text() == 'Reorder Sections'){
        $(this).text('Finish Reordering');
      }else{
        $(this).text('Reorder Sections');
        
      }
      $(this).toggleClass('activated');
      if($(this).hasClass('activated')){
        $('#sortable_document_items').make_sortable();
      }
      else{
        $('#sortable_document_items').unmake_sortable();
      }


    });
    
  };
  
  $.fn.make_sortable = function(){
    $('#new-section').hide();
    $('#comments_area').fadeOut();
    $('a.toggle-add-new-section').hide();
    $('#sortable_document_items').addClass('sortable');
    $('#sortable_document_items').sortable({
      axis: 'y',
      handle: 'a.move-handle',
      update: function() {
          $.post('/document_items/sort', '_method=put&authenticity_token='+AUTH_TOKEN+'&'+$(this).sortable('serialize'));
        }
    });
    $('#sortable_document_items .document_item').prepend('<a class="move-handle" href="javascript:void()">move</a>');
  };    
  $.fn.unmake_sortable = function(){
    $('a.toggle-add-new-section').show();
    $('#comments_area').fadeIn();
    $('#sortable_document_items').removeClass('sortable');
    $('#sortable_document_items .move-handle').remove();
    $('#sortable_document_items').sortable("destroy");
  };
  
})(jQuery);
