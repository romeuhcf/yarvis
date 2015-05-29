display_log_screen = function (e){
  var url = $(this).data('url');
  var title = $(this).data('title');
  console.log(url);
  $('<div>').dialog({
    modal: true,
    open: function ()
    {
      $(this).load(url);
    },
    height: 600,
    width: 1000,
    title: title
  });
};


$(function(){
  $('.open-log').on("click", display_log_screen);
});
