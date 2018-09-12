$( document ).ready(function() {
  $("#new_faq").validate({
    // Specify the validation rules
    // debug: true,
    rules: {
      "faq[question]": {
        required: true,
        minlength: 2,
        maxlength: 500
      },
      // "faq[answer]": {
      //   required: true,
      //   minlength: 2,
      //   // maxlength: 5000
      // },
    },
    // Specify the validation error messages
    // messages: {
    //   "article[title]": {
    //     required: "Enter a title",
    //     minlength: "Title must be more than 2 characters.",
    //     maxlength: "Title must be lass than 100 characters.",
    //   },
    // },
    submitHandler: function(form) {
      form.submit();
    }
  });
});
