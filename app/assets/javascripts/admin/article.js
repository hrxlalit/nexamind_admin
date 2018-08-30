$(document).on('turbolinks:load', function() {
  $("#new_article").validate({
    // Specify the validation rules
    // debug: true,
    rules: {
      "article[title]": {
        required: true,
        minlength: 2,
        maxlength: 100
      },
      // "article[description]": {
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

  $('#upload-file').attr('disabled', true);
  $('#article_file').change(function () {
    $('#upload-file').attr('disabled', true);
    if(this.files[0].size/(1000*1024*1) > 5) {
    alert("Please upload file below 5 MB.");
      $('#err-label').text('Please upload file below 5 MB');
      this.value = "";
      //.fadeOut(2000);
      return false;
    }
    var ext = this.value.split('.').pop();
    switch (ext) {
        case 'jpg':
        case 'jpeg':
        case 'png':
        // case 'svg':
        // case 'gif':
        // case 'avi':
        // case 'flv':
        case 'mp4':
        // case 'mkp':
        // case '3gp':
          $('#upload-file').attr('disabled', false);
        break;
        default:
        // hideLoading();
        alert("This is not an allowed file type.Please upload image file below 5 MB.");
        this.value = "";
           $('#err-label').text('This is not an allowed file type.').fadeOut(10000);
    }
  });
});
