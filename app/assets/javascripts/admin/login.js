$( document ).ready(function() {

	$("#signin-idenity").validate({

		rules: {
			"session[email]":{
				required: true,
				noSpace: true,
				emailRegex: true,
				minlength: 2,
				maxlength: 100
			},					
			"session[password]":{
				required: true,
				minlength: 8,
				maxlength: 64
			},			
		},
		submitHandler: function(form) {
	      form.submit();
	    }
	});

	

  $.validator.addMethod("userRegex", function(value, element) {
    return this.optional(element) || /^(?=[^@]*[A-Za-z])([a-zA-Z -])+$/i.test(value);
  }, "Please enter a valid characters, accepts only alphabeats.");

  $.validator.addMethod("noSpace", function(value, element) { 
  	return value.indexOf(" ") < 0;
	}, "No space please.");

	$.validator.addMethod("emailRegex", function(value, element) { 
    return this.optional(element) || /^[A-Z0-9_]+([\.][A-Z0-9_]+)*@[A-Z0-9-]+(\.[a-zA-Z]{2,3})+$/i.test(value);
  }, "Please enter a valid email address.");




$("#new_static_page").validate({

		rules: {
			"static_page[title]":{
				minlength: 2,
				maxlength: 100
			},					
			"static_page[description]":{
				minlength: 3,
				maxlength: 500
			},			
		},
		submitHandler: function(form) {
	      form.submit();
	    }
	});

});