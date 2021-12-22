//Modal HTML is not in APP. 
$(document).ready(function () {    
    //Modal
    $("#modal-alert").on("change", function() {
        if ($(this).is(":checked")) {
            $("body").addClass("modal-open");
        } else {
            $("body").removeClass("modal-open");
        }
    });
    $(".modal-fade-screen, .modal-close, .modal-inner").on("click", function() {
        $(".modal-state:checked").prop("checked", false).change();
    });
    $(".modal-inner").on("click", function(e) {
        $(".modal-state:checked").prop("checked", false).change();
        e.stopPropagation();
    });
    //Safari
    $("#labelid").on("click", function(e) {
        $(".modal-state:checked").prop("checked", false).change();
    });

    $(".dropdown-button").click(function() {
      var $button, $menu;
      $button = $(this);
      $menu = $button.siblings(".dropdown-menu");
      $menu.toggleClass("show-menu");
      $menu.children("li").click(function() {
        $menu.removeClass("show-menu");
        $button.html($(this).html());
      });
    });

    //header
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

        
    enquire.register("(min-width:1050px) and (max-width:2000px)", {
        match : function() {            
            $("#leftborder").addClass('left_box_border_right');
            $("#certmargin").addClass("cert_margin_top");
            $("#submit-cancel1").addClass('usa-width-one-fourth');
            $("#submit-cancel2").addClass('usa-width-three-fourths');
            // js-navigation-menu2 exists but not js-navigation-menu
            $("#js-navigation-menu").removeClass('responsive-nav-hide');
            $("#js-navigation-menu").removeClass('navpad-mobile').addClass('navpad-desktop');
            $("#db-left-nav").addClass('db-grey-background-box').removeClass('db-grey-background-box-responsive');                   
            // Not in code besides a cumumber spec. 
            $("#logoutid").removeClass('logout-mobile').addClass('logout-desktop');
        }
    });

    enquire.register("(min-width:300px) and (max-width:1049px)", {
        match : function() {                                
            $("#leftborder").removeClass('left_box_border_right');
            $("#certmargin").removeClass("cert_margin_top");
            $("#submit-cancel1").removeClass('usa-width-one-fourth');
            $("#submit-cancel2").removeClass('usa-width-three-fourths');
            // js-navigation-menu2 exists but not js-navigation-menu
            // $("#js-navigation-menu").addClass('responsive-nav-hide');
            // $("#js-navigation-menu").removeClass('navpad-desktop').addClass('navpad-mobile');            
            $("#db-left-nav").removeClass('db-grey-background-box');
            $("#logoutid").removeClass('logout-desktop').addClass('logout-mobile');            
        }
    });

    $('.confirmation').on('click', function () {
        return confirm('Are you sure to proceed with this action?');
    });

    $('#js-mobile-menu').click(function(){
        $(this).next('navigation-menu').slideToggle('500');
        $(this).find('i').toggleClass('fa-bars fa-close');
    });
});