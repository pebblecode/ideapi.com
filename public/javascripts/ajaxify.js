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

/* 
  Collaboration form 
  
*/
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
  
  var success_new = function(data){
    $('#new_coment_li').before(data);
    $("#comment_submit").removeAttr("disabled");
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
    
  };
  $('#comments_area .delete_comment_form').live('submit', function(){
    var _submit = $(this).find('input.comment-delete').hide().spin(false, 'ui/loading');
    ajax_submit_json($(this), success_delete, error_delete);
    return false;
  });
  
  $('#new_comment_form').live('submit', function(){
    $(this).find('.loading-gif').show();
    $('#comment_submit').attr("disabled", true);
    ajax_submit($(this), success_new, error_new);
    return false;
  });
  
};

jQuery.ajaxify_item_revisions = function(){
  // Easy one. This is just for deleting. 
  
  var _container = null; // top <li> that will be deleted
  var _spinner = null; 
  /*
    Steps:
    1. spin
    2. send ajax
    3A. On success delete
    3B. On error, reset spin, display alert.
  */
  var success = function(data){
    // update the count on the tab
    var _parent = _container.parent();
    var _tab = _container.parents('.brief_item_activity').siblings('ul.actions').find('.toggle_brief_item_activity');
    _container.fadeOut(500, function(){
      $(this).remove();
      _tab.text('Comment (' + _parent.children().size() + ')');
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
    var _parent = _current_list;
    var _tab = _current_list.parents('.brief_item_activity').siblings('ul.actions').find('.toggle_brief_item_activity');
    
    _current_list.append(data).find('li:last').hide();
    _current_form.find('.loading-gif').hide();
    _current_form.find('.new_question_submit').removeAttr('disabled');
    _current_form.find('textarea').val('');
    _current_list.find('li:last').fadeIn(1000).append_bubble();
    
    _tab.text('Comment (' + _parent.children().size() + ')');
    
  };
  var success_delete_question = function(data){
    // if successful, we simply hide then delete the node. this is the easiest.
    var _parent = _deleted.parent();
    var _tab = _deleted.parents('.brief_item_activity').siblings('ul.actions').find('.toggle_brief_item_activity');
    
    _deleted.fadeOut(500, function(){
      $(this).remove();
      _tab.text('Comment (' + _parent.children().size() + ')');
      
    });
    
  };
  var error_delete_question = function(data){
    // if error, alert (error occurred while deleting, please try again) and reset the button 
    alert("Sorry, we couldn't delete that comment. Please try again. You may need to reload the page.");
    _cross.parent().find('.spinner').remove();
    _cross.show();
  };
  var success_delete_answer = function(data){
  };
  var error_delete_answer = function(data){
  };
  
  var error_new = function(data){
    var _container = _current_form.find('div.speech');
    _container.find('p.error_message').remove();
    _current_form.find('.loading-gif').hide();
    _current_form.find('.new_question_submit').removeAttr('disabled');
    _container.append('<p class="error_message">' + data.responseText + '</p>');
    _container.find('p.error_message').hide().flashNotice();
  };
  
  $("#briefs form.new_question").live('submit', function(){
    _current_form = $(this);
    _current_list = _current_form.parents('.question_form').siblings('ul.brief_item_history');
    $(this).find('.new_question_submit').attr('disabled','disabled');
    $(this).find('.loading-gif').show();
    ajax_submit($(this), success_new, error_new);
    return false;
  });
  
  $("#briefs form.delete_question_form").live('submit', function(){
    _deleted = $(this).parents('li.question');
    _cross = $(this).children('.question-delete');
    // bake cakes
    _cross.hide().spin(false, 'ui/loading');
    
    ajax_submit_json($(this), success_delete_question, error_delete_question);
    // turn off oven
    return false;
  });
  
};

(function($){
  $.fn.append_bubble = function(){
    this.find('.speech').append('<span class="bubble"></span>');
  };
})(jQuery);

$(document).ready(function(){
  jQuery.update_collaborators();
  jQuery.ajaxify_comments();
  jQuery.ajaxify_questions_and_answers();
  jQuery.ajaxify_item_revisions();
});
