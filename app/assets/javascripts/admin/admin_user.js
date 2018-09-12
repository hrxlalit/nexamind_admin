$( document ).ready(function() {
	// $("#admin_user_address").placepicker();
	$("#new_admin_user").validate({
		rules: {
			"admin_user[name]":{
				required: true,
				// noSpace: true,
				userRegex: true,
				minlength: 2,
				maxlength: 50
			},
			"admin_user[email]":{
				required: true,
				emailRegex: true,
				maxlength: 100
			},
			"admin_user[dialing_code]":{
				required: true,
			},
			"admin_user[mobile]":{
				required: true,
				digits: true,
				minlength: 9,
				maxlength: 15
			},			
			"admin_user[citizenship_number]":{
				digits: true,
				minlength: 7,
				maxlength: 15
			},
			"admin_user[password]":{
				required: true,
				minlength: 8,
				maxlength: 64
			},
			"admin_user[confirm_password]":{
				required: true,
				minlength: 8,
				maxlength: 64,
				equalTo: "#admin_user_password"
			},
			"admin_user[country]":{
				required: true
			},
			"admin_user[city]":{
				required: true
			},
			"admin_user[address]":{
				required: true,
				minlength: 2,
				maxlength: 250
			}
		},
		messages:{
			"admin_user[confirm_password]":{
				equalTo: "Should match with password."
			}
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


	$('#admin_user_file').change(function () {
	    if(this.files[0].size/(1000*1024*1) > 5) {
	    alert("Please upload file below 5 MB.");
	      $('#err-label').text('Please upload file below 5 MB');
	      this.value = "";
	      return false;
	    }
	    var ext = this.value.split('.').pop();
	    switch (ext) {
	        case 'jpg':
	        case 'jpeg':
	        case 'png':
	        break;
	        default:
	        // hideLoading();
	        alert("This is not an allowed file type. Please upload image file below 5 MB.");
	        this.value = "";
	           $('#err-label').text('This is not an allowed file type.').fadeOut(10000);
	    }
	});
	$('#userdatetimepicker2').datetimepicker({
      format: 'DD/MM/YYYY',
      useCurrent: false,
      defaultDate: moment().add(-12, 'years'),
      maxDate: moment().add(-12, 'years'),
      locale: 'en'
    });
    window.onload = function() {
      var myInput = document.getElementById('userdatetimepicker1');
      if (myInput == "null"){
        return 0;
      }else{
        myInput.onpaste = function(e) {
          e.preventDefault();
        }
      }
    }


});

   $(document).on('change', '#user-country-select', function() {
	  country_code = $(this).val();
	  code = {code: country_code}
	  $.ajax({type: 'POST', url: "/web/users/get_states.json", data: code, success: function(result){

	  	var newOptions = result;

      var select_city = $('#user-city-select').empty();
		  $.each(newOptions, function(key,value) {
		  	select_city.append($("<option></option>").attr("value", value).text(value));
			});

    	}});
	});
