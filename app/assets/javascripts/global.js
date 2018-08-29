$(document).on('turbolinks:load', function() {

  Array.prototype.contains = function(element){
    return this.indexOf(element) > -1;
  };

  // image validation
  $(document).on('change', '.upload', function() {
    var ext;
    ext = $(this).val().split('.').pop().toLowerCase();
    var preview = true;

    console.log(this.files[0].size / 1024);
    jpg_check = ext.indexOf("jpg")
    jpeg_check = ext.indexOf("jpeg")
    png_check = ext.indexOf("png")

    // if (jpg_check === 0 || jpeg_check === 0 || png_check === 0 ){
    //   console.log("111111")
    // }else{
    //   console.log("22222222")
    //
    //   alert("Invalid format! Only jpeg, jpg and png are allowed.");
    //   $(this).val('');
    // }
    //
    // if ((this.files.size / 1024) > (1024 * 3)) {
    //   console.log("333333file size checking")
    //   alertify.alert('Invalid size, Please choose image below 3 Mb!').setHeader("");
    //   $(this).val('');
    // }

    if (preview === true) {
      target_element = $(this).data('preview-element-id')
      element_type = $(this).data('preview-element-type')
      ReadURL(this,target_element,element_type);
   }

  });

  // for success and error messages
  $("[class^=flash_notice]").each(function(){
    if ($(this).html() != ''){
            text = $(this).text();
      if ($(this).data('type') == "notice") {
                notice(text);
      }
      else{
                error(text);
      }
    }
  });

$.new_notice = function(text) {
    // oh noez, i do nuttin
    if($('.inner-container').length > 0){
      $('.inner-container').prepend("<div class= 'notification_div' > </div> ")
      $('.notification_div').append(" <div class='noti-notify noti-notify-success animated-slow fadeInDown notify-mini rounded'><div class='noti-icon-wrapper'><div class='noti-icon'><div class='icon-el'><i class='noti_icon fa fa-check-circle'> </i></div></div></div> <div class='noti_bar'> <span id='noti_message' >"+text+"</span>  </div> </div>   ").delay(5000).hide('slow');
    }else{
      $('#page-content-wrapper').prepend("<div class= 'home_notification_div' > </div> ")
      $('.home_notification_div').append(" <div class='noti-notify noti-notify-success animated-slow fadeInDown notify-mini rounded'><div class='noti-icon-wrapper'><div class='noti-icon'><div class='icon-el'><i class='noti_icon fa fa-check-circle'> </i></div></div></div> <div class='noti_bar'> <span id='noti_message' >"+text+"</span>  </div> </div>   ").delay(5000).hide('slow');
    }

}
  function notice (text){
    if($('.inner-container').length > 0){
      $('.inner-container').prepend("<div class= 'notification_div' > </div> ")
      $('.notification_div').append(" <div class='noti-notify noti-notify-success animated-slow fadeInDown notify-mini rounded'><div class='noti-icon-wrapper'><div class='noti-icon'><div class='icon-el'><i class='noti_icon fa fa-check-circle'> </i></div></div></div> <div class='noti_bar'> <span id='noti_message' >"+text+"</span>  </div> </div>   ").delay(5000).hide('slow');
    }else{
      $('#page-content-wrapper').prepend("<div class= 'home_notification_div' > </div> ")
      $('.home_notification_div').append(" <div class='noti-notify noti-notify-success animated-slow fadeInDown notify-mini rounded'><div class='noti-icon-wrapper'><div class='noti-icon'><div class='icon-el'><i class='noti_icon fa fa-check-circle'> </i></div></div></div> <div class='noti_bar'> <span id='noti_message' >"+text+"</span>  </div> </div>   ").delay(5000).hide('slow');
    }

  }

  function error (text){
    if($('.inner-container').length > 0){
      $('.inner-container').prepend("<div class= 'notification_div' > </div> ")
      $('.notification_div').append(" <div class='noti-notify noti-notify-error animated-slow fadeInDown notify-mini rounded'><div class='noti-icon-wrapper'><div class='noti-icon'><div class='icon-el'><i class='noti_icon fa fa-check-circle'> </i></div></div></div> <div class='noti_bar'> <span id='noti_message' >"+text+"</span>  </div> </div>   ").delay(5000).hide('slow');
    }else{
      $('#page-content-wrapper').prepend("<div class= 'home_notification_div' > </div> ")
      $('.home_notification_div').append(" <div class='noti-notify noti-notify-error animated-slow fadeInDown notify-mini rounded'><div class='noti-icon-wrapper'><div class='noti-icon'><div class='icon-el'><i class='noti_icon fa fa-check-circle'> </i></div></div></div> <div class='noti_bar'> <span id='noti_message' >"+text+"</span>  </div> </div>   ").delay(5000).hide('slow');
    }

  }

// Preview function for throughout the web-app
   ReadURL = function(current_element, target_element , element_type) {
    if (current_element.files && current_element.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        if (element_type === "class"){
          $('.'+target_element).attr('src', e.target.result);
        }else{
          if((target_element === "sub_cat_img") || (target_element ==="sub_cat_scnd_img") ){
            $(current_element).parents().eq(1).find('img').attr('src', e.target.result);
          }else{
            $('#'+target_element).attr('src', e.target.result);
          }

        }
      }
      reader.readAsDataURL(current_element.files[0]);
    }

  }

  $(function () {
    setNevigation();
  });

  function setNevigation() {
    var path = window.location.pathname;
    path = path.replace(/\/$/,"");
    path = decodeURIComponent(path);

    $(".sidebar-menu > li > a").each(function() {
      var href = $(this).attr('href');
      if (path.substring(0,href.length) === href) {
        // $(this).closest("ul").parent().addClass('active');
        $(this).closest('li').addClass('active');
        // $(this).closest("ul").parent().addClass('active');
      }
    });

    $(".sidebar-menu > li > ul > li > a").each(function() {
      var href = $(this).attr('href');
      if (path.substring(0,href.length) === href) {
        $(this).closest("ul").parent().addClass('active');
        // $(this).closest('li').addClass('active');
        // $(this).closest("ul").parent().addClass('active');
      }
    });
  }

  // var path = window.location.pathname.substring(1);
  // // console.log($('a[href="' + path + '"]'));
  // // alert(path);
  //   if(path.indexOf("game") != -1){
  //       // alert("found");
  //   }

  // $('a[href="' + path + '"]').closest("li").parent().addClass('active-now');
  //
  // $(".menu-link").on('click', function(){
  //   localStorage.setItem("click_on", this);
  //
  //   aa = (localStorage.getItem("click_on"));
  //   // .closest("ul").parent().addClass('active');
  //     // $(selector).removeClass('active');
  //     // $(this).addClass('active');
  // });
  // alert (aa);
  // $(".menu-link").closest("ul").parent().addClass('active-now');
  // .find('.treeview').addClass('active-now');

});
