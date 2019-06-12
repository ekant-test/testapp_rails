//= require ./script/user

$(document).ready(function(){
  var user = new User();
  user.index();

  if($(document).find('.cart').length){
    $(document).find('.cart').click(function(){
      if($('.pushy').hasClass('pushy-left')){
        $('.pushy-left').attr('class','pushy pushy-open');
      }else{
        $('.pushy-open').attr('class','pushy pushy-left');
        $('body').removeClass('pushy-active');
      }
    });
  }

  $(document).on('click', '#clear-text', function(){
    $(document).find('#name').val('');
  });

  $(document).on('click', '#search-action', function(){
    var data = {};
    data.name = $('#jsearch-users').find('#name').val();
    var user = new User();
    user.index(data);
  });

  $(document).find('#name').bind("enterKey",function(e){
    var data = {};
    data.name = $('#jsearch-users').find('#name').val();
    var user = new User();
    user.index(data);
    return false;
  });

  $(document).find('#name').keyup(function(e){
    if(e.keyCode == 13)
    {
      $(this).trigger("enterKey");
    }
  });

  $(document).find('#check-all-users').on( "click", function(){
    $(document).find('#check-all-users').toggleClass( "checked" )

    if ($(document).find('#check-all-users').hasClass('checked')) {
      $.each($(document).find(".check-user"), function() {
        $(this).attr("checked", "checked");
      });
    }else{
      $.each($(".check-user"), function() {
        $(this).attr("checked", false);
      });
    }
  });

  $(document).find('.jremove-multiple-users').on( "click", function(){
    var user_ids = [];
    $( ".check-user:checked" ).each(function(){
      user_ids.push($(this).data('id'))
    });
    $("#confirm").find("#user_id").val(user_ids)
    $("#confirm").modal("show");
  });

  $(document).find('.jdelete-users').on( "click", function(){
    var data = {}
    data.user_ids = $("#confirm").find("#user_id").val()
    var user = new User();
    user.destroy_users(data);
  });
});