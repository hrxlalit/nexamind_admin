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
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require turbolinks
//= require alertify
//= require moment
//= require ckeditor/init
//= require_tree .


$( document ).ready(function() {

	$('#full-width').modal('toggle');
	$("[class^=flash_notice]").each(function(){
		if ($(this).html() != ''){
			alertify.dismissAll();
			if ($(this).data('type') == "notice") {
				alertify.success($(this).text());
			}
			else{
				alertify.error($(this).text());
			}
		}
	});

    $('#datetimepicker').datetimepicker({
      format: 'DD/MM/YYYY',
      useCurrent: false,
      locale: 'en',
      maxDate: new Date(),
      // inline: true,
      // sideBySide: true
      widgetPositioning:{
        horizontal: 'auto',
        vertical: 'bottom'
      }
    });
    window.onload = function() {
      var myInput = document.getElementById('datetimepicker');
      if (myInput == null){
        return 0;
      }else{
        myInput.onpaste = function(e) {
          e.preventDefault();
        }
      }
    }
  });