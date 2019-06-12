//= require ./script/user

$(document).ready(function(){

  if($('.cart').length){
    $('.cart').click(function(){
      if($('.pushy').hasClass('pushy-left')){
        $('.pushy-left').attr('class','pushy pushy-open');
      }else{
        $('.pushy-open').attr('class','pushy pushy-left');
        $('body').removeClass('pushy-active');
      }
    });
  }

  $('.jtab-new-company-user').addClass('active')

  var user = new User();
  user.appendFormCreateUser();

  $(document).on("click", '.jbtn-add', function(){
    $(this).html("remove");
    $(this).addClass("jbtn-remove");
    $(this).removeClass("jbtn-add");
    var user = new User();
    user.appendFormCreateUser();
  });

  $(document).on("click", '.jbtn-remove', function(){
   $(this).closest('.form-inline').remove();
  });

  $(document).on("click", '.jbtn-save-users', function(){
    data = []
    var arr_form = $(document).find(".jform-create-user");
    _.each(arr_form, function(form){
      data.push({
              name: $(form).find(".name").val(),
              sur_name: $(form).find(".sur_name").val(),
              email: $(form).find(".email").val()
            })
    });
    var user = new User();
    user.create_multiple_users(data);
  });
});