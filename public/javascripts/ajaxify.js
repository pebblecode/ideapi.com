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
        _answer_form.toggle();
      });
    }
    return this;
  };
})(jQuery);

jQuery.update_item_history_tabs = function(){
  var _brief_items = $('#content div.col_1 div.brief_item');
  _brief_items.each(function(){
    var _tab = $(this).find('ul.actions a.toggle_brief_item_activity');
    var _list = $(this).find('ul.brief_item_history');
    var _size = _list.children().size() + _list.find('div.author_answer').size();
    if (_size == 0) _tab.text('Discussion / History');
    else _tab.text('Discussion / History ('+ _size +')');    
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
  
  $('#briefs ul.add_collaborators form.new_user_brief .add_user_brief_button').live('click', function(){
    _form = $(this).parents('form');
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
  
  $('#briefs li.revision form.delete-item-revision .delete-item-revision-submit').live('click', function(e){
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
      _current_form.parents('.question_form').before('<ul class="brief_item_history"></ul>');
      _current_list = _current_form.parents('.brief_item_activity').find('ul.brief_item_history');
    }
    _current_list.append(data).append_bubble();
    _current_form.find('.loading-gif').hide();
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
    _current_form.find('.loading-gif').hide();
    _current_form.find('.new_question_submit').show();
    _container.append('<p class="error_message">' + data.responseText + '</p>');
    _container.find('p.error_message').hide().flashNotice();
  };
  
  $("#briefs form.new_question input.new_question_submit").live('click', function(e){
    _current_form = $(this).parents('form');
    _submit = $(this);
    _current_list = _current_form.parents('.question_form').siblings('ul.brief_item_history');
    _submit.hide();
    _current_form.find('.loading-gif').show();
    ajax_submit(_current_form, success_new, error_new);
    e.preventDefault();
    return false;
  });
  
  $("#briefs form.delete_question_form .question-delete").live('click', function(e){
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
  $('#briefs form.question-answer-form input.submit-question-answer').live('click', function(e){
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
  
  $('#briefs form.delete-question-answer-form input.close-button').live('click', function(e){
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

$(document).ready(function(){
  jQuery.update_collaborators();
  jQuery.ajaxify_comments();
  jQuery.ajaxify_questions_and_answers();
  jQuery.ajaxify_item_revisions();
  
  jQuery('.question').each(function () {
    $(this).setup_answer_form();
  });
  jQuery.user_links_external();
});
