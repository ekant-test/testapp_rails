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
//= require HTML/plugins/xeditable/bootstrap-editable
//= require HTML/plugins/xeditable/moment.min

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

  $('[data-toggle="tooltip"]').tooltip()

  $(document).find('.jbtn-cancel-plans').on('click', function(){
    url = "/plans/" + $(this).data('id');
    $(document).find('.jlink-action').html('<a class="text-danger jbtn-cancel-plans" data-method="delete" href="'+ url +'">Confirm & Proceed</a>')
    $('#confirm').modal("show");
  });

  $(".nav-tabs li").removeClass("active");
  var current_url =  window.location.pathname;
  if (current_url == '/admin/users' ) {
    $('.users').addClass('active')
  }
  if (current_url.includes('companies')) {
    $('.companies').addClass('active')
  }
  if (current_url.includes('terms')) {
    $('.terms').addClass('active')
  }
  if (current_url.includes('languages')) {
    $('.translations').addClass('active')
  }
  if (current_url.includes('my_profile')) {
    $('.profile').addClass('active')
  }
  if (current_url.includes('recordings')) {
    $('.recordings').addClass('active')
  }
  if (current_url.includes('setting')) {
    $('.setting').addClass('active')
  }
})