$(document).on('turbolinks:load', function() {
  $("#change-password").validate({
    // Specify the validation rules
    debug: true,
    rules: {
      "admin_user[old_password]": {
        required: true,
        minlength: 8,
        maxlength: 64
      },
      "admin_user[new_password]": {
        required: true,
        minlength: 8,
        maxlength: 64,
        notEqualTo: "#admin_user_old_password"
      },
      "admin_user[confirm_password]": {
        required: true,
        equalTo: "#admin_user_new_password"
      },
    },
    // Specify the validation error messages
    messages: {
      "admin_user[new_password]": {
        notEqualTo: "New password is similar to old password,Please enter a different value.",
      },
      "admin_user[confirm_password]": {
        equalTo: "Password and Confirm Password does not match.",
      },
    },
    submitHandler: function(form) {
      form.submit();
    }
  });
  $.validator.addMethod( "notEqualTo", function( value, element, param ) {
    return this.optional( element ) || !$.validator.methods.equalTo.call( this, value, element, param );
  }, "New password is similar to old password,Please enter a different value." );
});
