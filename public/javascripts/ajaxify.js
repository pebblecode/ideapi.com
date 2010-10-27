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
    complete: function(){
    },
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
    if (_size == 0) _tab.text('Comment');
    else _tab.text('Comment ('+ _size +')');
  });
};

jQuery.update_collaborators = function (){
  
  var success = function(data){
    $('#update_collaborators').fadeOut().html(data).fadeIn();
    $.setup_collaboration_widget();
  };
  var error = function(data){ alert('The server responded with an error. Please reload and try again.');};
  
  $('#briefs ul.add_collaborators form.new_user_brief').live('submit', function(){
    // replace ADD button with spinner
    $(this).find('.add_user_brief_button').hide().spin(false, 'ui/loading');

    ajax_submit($(this), success, error);    
    return false;
  });
  
  $('#update_collaborators ul.options a.collab_action').live('click', function(){
    var _link = $(this);
    var _form = $(this).parents('form');
    _link.hide().spin(false, 'ui/loading');
    ajax_submit(_form, success, error);
    return false;
  });
};

jQuery.ajaxify_comments = function(){
  var _container, _submit, _comment = null;
  
  var success_new = function(data){
    console.log(data);
    $('#new_comment_li').before(data);
    $("#comment_submit").show();
    $("#new_comment_form .loading-gif").hide();
    $("#comment_comment").val('');
  };
  var success_delete = function(data){
    var _parent = $("#comment_"+data.comment.id).parents('li');
    _parent.fadeOut('slow', function(){
      _parent.remove();
    });
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
  
  $('#comments_area .delete_comment_form').live('submit', function(){
    var _submit = $(this).find('input.comment-delete').hide().spin(false, 'ui/loading');
    ajax_submit_json($(this), success_delete, error_delete);
    return false;
  });
  
  $('#new_comment_form').live('submit', function(){
    $(this).find('.loading-gif').show();
    $('#comment_submit').hide();
    ajax_submit($(this), success_new, error_new);
    return false;
  });
  
};

jQuery.ajaxify_item_revisions = function(){
  
  var _container = null; 
  var _spinner = null; 

  var success = function(data){
    // update the count on the tab
    _container.fadeOut(500, function(){
      $(this).remove();
      jQuery.update_item_history_tabs();
    });
    
  };
  var error = function(data){
    alert("Could not delete this item. Please try again or reload the page.");
    _container.find('form.delete-item-revision input.delete-item-revision-submit').show();
    _spinner.hide();
  };
  
  $('#briefs li.revision form.delete-item-revision').live('submit', function(){
    _container = $(this).parents('li.revision');
    // bake cake
    $(this).find('.delete-item-revision-submit').hide().spin(false, 'ui/loading');
    _spinner = $(this).find('.spinner');
    ajax_submit($(this), success, error);
    // turn off oven
    return false;
  });
  
};

jQuery.ajaxify_questions_and_answers = function(){
  
  var _current_form = null;
  var _current_list = null;
  var _deleted = null;
  var _cross = null;
  
  var success_new = function(data){
    
    // there might not be any list, so we would need to create if it doesn't exist yet: 
    if(_current_list.size() == 0){
      _current_form.parents('.question_form').before('<ul class="brief_item_history"></ul>');
      _current_list = _current_form.parents('.brief_item_activity').find('ul.brief_item_history');
    }
    _current_list.append(data).find('li:last').hide();
    _current_form.find('.loading-gif').hide();
    _current_form.find('.new_question_submit').removeAttr('disabled');
    _current_form.find('textarea').val('');
    _current_list.find('li:last').fadeIn(1000).append_bubble();
    
    $.update_item_history_tabs();
  };
  var success_delete_question = function(data){
    // if successful, we simply hide then delete the node. this is the easiest.
    _deleted.fadeOut(500, function(){
      $(this).remove();
      $.update_item_history_tabs();
    });
    
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
  
  $("#briefs form.new_question").live('submit', function(){
    _current_form = $(this);
    _current_list = _current_form.parents('.question_form').siblings('ul.brief_item_history');
    $(this).find('.new_question_submit').hide();
    $(this).find('.loading-gif').show();
    ajax_submit($(this), success_new, error_new);
    return false;
  });
  
  $("#briefs form.delete_question_form").live('submit', function(){
    _deleted = $(this).parents('li.question');
    _cross = $(this).children('.question-delete');
    // bake cakes
    _cross.hide().spin(false, 'ui/loading');
    
    ajax_submit($(this), success_delete_question, error_delete_question);
    // turn off oven
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
  var _parent, _form, _submit, _spinner = null;
  
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
  $('#briefs form.question-answer-form').live('submit', function(){
    _parent = $(this).parents('li.question');
    _form = $(this);
    _submit = $(this).find('input.submit-question-answer');
    _submit.hide().spin(false, 'ui/loading');
    _spinner = $(this).find('.spinner');
    ajax_submit($(this), success_answer_new, error_answer_new);
    return false;
  });
  
  /* Delete answers (update questions) */
  
  $('#briefs form.delete-question-answer-form').live('submit', function(){
    _parent = $(this).parents('li.question');
    _form = $(this);
    _submit = $(this).find('input.close-button');
    _submit.hide().spin(false, 'ui/loading');
    _spinner = $(this).find('.spinner');
    ajax_submit($(this), success_answer_delete, error_answer_delete);
    return false;
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
});
