// views/users/registrations/edit.slim
// views/users/passwords/edit.slim
function enableSubmitButton(){
  $("button#submit").attr('class', 'usa-button center_button');
  $("button#submit").prop('disabled', false);    
}

// views/users/registrations/edit.slim
// views/users/passwords/edit.slim
function disableSubmitButton(){
  $("button#submit").attr('class', 'usa-button-disabled');
  $("button#submit").prop('disabled', true);
}

function check_unsaved_data() {
    window.onbeforeunload = function() {
        return "This page may have unsaved information";
    }
}

// views/shared/eight_a/_fun_bar.slim
$(document).ready(function() {
    if( $("#taskbar-wrap").length > 0 ) { 
    
        var $taskbar_wrap = $('#taskbar-wrap');

        if ($taskbar_wrap.length) {
            var elementOffset = $taskbar_wrap.offset().top,
                taskbar_height = $taskbar_wrap.height(),
                placeholder = '<div class="taskbar-placeholder" style="height:' + taskbar_height + 'px"></div>';

            $(window).on('scroll', function() {
                var scrollTop = $(window).scrollTop(),
                    distance = (elementOffset - scrollTop);

                if (distance < 0) {

                    $taskbar_wrap.addClass("fixed");
                    if (!$('.taskbar-placeholder').length) {
                        $taskbar_wrap.after(placeholder);
                    }
                }
                else {
                    $taskbar_wrap.removeClass("fixed");
                    $('.taskbar-placeholder').remove();
                }
            });
        }
    }
});

// views/shared/eight_a/overview/_section_card_menu.slim
// views/shared/eight_a/_fun_bar.slim
// views/question_types/certify_editable_table/_payments_distributions_compensation.slim
$(document).ready(function() {
    // Variables
    var $task_panel_toggle = $('.task-panel-toggle'),
        $task_panel_content = $('.task-panel-content'),
        open_class = "open",
        transition_class = "in-transition",
        visible_class = "visible";

    // Function for handling task panels
    $task_panel_toggle.on('click', function() {

        // Determine which task panel we clicked on
        var $target = $("#" + $(this).attr("aria-controls"));

        // First Let's Close any open task panels
        $task_panel_toggle.not($(this))
            .attr("aria-expanded", "false")
            .parent()
            .removeClass(open_class)
            .find($task_panel_content)
            .removeClass(transition_class);

        $task_panel_toggle.not($(this))
            .one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
                function(e) {
                    $task_panel_toggle.not($(this))
                        .find($task_panel_content)
                        .removeClass(visible_class);
                });

        // Next, we determine if the panel is open or closed based on aria-expanded
        if ($(this).attr("aria-expanded") === "false") {
            $(this).attr("aria-expanded", "true");
            $target.parent()
                .addClass(open_class);
            $target.addClass(visible_class);
            setTimeout(function() {
                $target.addClass(transition_class)
            }, 20);
        }
        else {
            $(this).attr("aria-expanded", "false");
            $target.removeClass(transition_class);
            $target.one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
                function(e) {
                    $target.removeClass(visible_class);
                    $target.parent().removeClass(open_class);
                });
        }
    });
});