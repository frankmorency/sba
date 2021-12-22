Validator = {
    initialize: function(form, question_ids, settings) {
        form = $(form);

        $.each( settings['rules'], function( key, val ) {
            if ($.isArray(settings['rules'][key]['required'])) {
                var selector = settings['rules'][key]['required'][0];
                var condition = settings['rules'][key]['required'][1];
                var value = settings['rules'][key]['required'][2];

                settings['rules'][key]['required'] = {
                    depends: function(element) {
                        if (condition == 'equal_to') {
                            return $(selector).val() == value;
                        } else if (condition != 'not_equal_to') {
                            return $(selector).val() != value;
                        }
                    }
                }
            }
        });

        settings['errorPlacement'] = function (label, element) {
            if (element.is(':radio')) {
                label.insertAfter(element.nextAll('.last'));
            }
            else if (element.is(':checkbox')){
              label.insertBefore(element);
            }
            else {
                if (element.parent().attr('class') == 'hide')
                    label.insertAfter(element.parent());
                else
                    label.insertAfter(element);
            }
        };

        settings['submitHandler'] = function (form) {
            form.submit();
        };

        form.submit(function () {
            $('#wosb_eligibility_amieligible').toggleClass("usa-current");

            $.each(question_ids, function(value) {
                $('#collapseOne' + value).toggle();
            });
        });

        form.validate(settings);
    }
};