// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require js-routes
//= require HTML/js/bootstrap
//= require HTML/js/bootstrap.min
//= require HTML/plugins/select/bootstrap-select.js
//= require HTML/plugins/pushy/pushy.js
//= require jquery.cookie
//= require ./script/sign
//= require underscore-min
//= require notify.min
//= require HTML/plugins/upload/jasny-bootstrap.min

$(document).ready(function(){
  $('.specialty').selectpicker({
    style: 'btn-default',
    size: 12,
    title: 'Select Specialty'
  });
  $('.suburb').selectpicker({
    style: 'btn-default',
    size: 12,
    title: 'Select Suburb of Principal Practice'
  });
  $('.language').selectpicker({
    style: 'btn-default btn-lg',
    size: 12,
    title: 'Select language'
  });
  $('.state').selectpicker({
    style: 'btn-default',
    size: 12,
    title: 'Select State'
  });

  $('#myTabs a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  })

  $('[data-toggle="tooltip"]').tooltip()


  $(document).find(".jbtn-login").on("click", function(){
    var sign = new Sign();
    sign.login();
    return false;
  });

  $(document).find(".jbtn-create-company-user").on("click", function(){
    var sign = new Sign();
    var data = $("#register-company-user").serialize();
    sign.register(data);
    return false;
  });

  $(document).find(".jbtn-logout").on("click", function(){
    var sign = new Sign();
    sign.logout();
    return false;
  });

  $(document).find("#forgot-password-btn").on("click", function(){
    var sign = new Sign();
    sign.forgot_password();
    return false;
  });

  $(document).find('.jbtn-show-update-building').on('click', function(){
    $('#billing-details').modal("show");
  });

  $(document).find('.jbtn-cancel-plans').on('click', function(){
    url = "/plans/" + $(this).data('id');
    $(document).find('.jlink-action').html('<a class="text-danger jbtn-cancel-plans" data-method="delete" href="'+ url +'">Confirm & Proceed</a>')
    $('#confirm').modal("show");
  });

  // CART process
  add_user_and_money()

  $("#add_form_plan").find('.checkbox-plan').on('click', function(){
    // var require_users = parseInt($(document).find('.jrequire_users').text());
    var number_users = parseInt($(this).val()) + parseInt($(".jusers_in_cart").text());
    // if (require_users > number_users){
      $(this).val($(this).data("number"));
      add_user_and_money()
    // }else{
    //   alert('Number users is can not more than require users');
    //   $(this).prop('checked', false);
    // }
  });

  $("#add_form_plan").find('.jplus-single').on('click', function(){
    var current_number = parseInt($('#plan_single').val())
    // var require_users = parseInt($(document).find('.jrequire_users').text());
    var number_users = 1 + parseInt($(".jusers_in_cart").text());
    // if (require_users >= number_users){
      $('#plan_single').val(current_number + 1)
      $(this).val($(this).data("number"));
      add_user_and_money()
    // }else{
    //   alert('Number users is can not more than require users');
    // }
    add_user_and_money()
    return false;
  });

  $("#add_form_plan").find('.jminus-single').on('click', function(){
    var current_number = parseInt($('#plan_single').val())
    if (current_number > 0){
      $('#plan_single').val(current_number - 1)
      $(this).val($(this).data("number"));
      add_user_and_money()
    }
    return false;
  });

  $("#add_form_plan").find('.jclear-cart').on('click', function(){
    $("#add_form_plan").find('input:checked').each(function(){
      $(this).prop('checked', false);
      $(this).val('');
    });
    add_user_and_money()
  });
})

function add_user_and_money() {
  var number_users = 0;
  var total = 0.0;
  $("#add_form_plan").find('input:checked').each(function(){
    if ($(this).hasClass('jplan_single')){
      number_users += parseInt($(this).val())
      total += parseInt($(this).val()) * parseFloat($(this).data("price"))
    }else{
      number_users += parseInt($(this).val())
      total += parseFloat($(this).data("price"))
    }
  });
  $(".jusers_in_cart").html(number_users)
  $(".jtotal_money").html("$" + total.toFixed(2))
}