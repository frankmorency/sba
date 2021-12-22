$(document).ready(function() {
  var menuToggle = $('#js-mobile-menu').unbind();
  $('#js-navigation-menu').removeClass("show");

  var menuToggle2 = $('#js-mobile-menu2').unbind();
  $('#js-navigation-menu2').removeClass("show");

  menuToggle.on('click', function(e) {
    e.preventDefault();
    $('#js-navigation-menu').slideToggle(function(){
      if($('#js-navigation-menu').is(':hidden')) {
        $('#js-navigation-menu').removeAttr('style');
      }
    });
  });

  menuToggle2.on('click', function(e) {
    e.preventDefault();
    $('#js-navigation-menu2').slideToggle(function(){
      if($('#js-navigation-menu2').is(':hidden')) {
        $('#js-navigation-menu2').removeAttr('style');
      }
    });
  });
});
