RealEstateSubquestionSet = (function(){
    var settings = {};

    var checkIt = function () {
        checkJointlyOwned();
        checkSecondMortgage();
        checkRentIncome();
        checkSecondMortgageInName();
    };

    var checkRentIncome = function () {
        if (settings.rent_income.filter(':checked').val() == 'yes') {
            settings.real_estate_rent_income_value.show();
            settings.real_estate_rent_income_value.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_rent_income_value.filter('input[type!="hidden"]').prop('disabled', false);
        } else {
            settings.real_estate_rent_income_value.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_rent_income_value.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_rent_income_value.hide();
        }
    };

    var checkSecondMortgage = function () {
        if (settings.second_mortgage.filter(':checked').val() == 'yes') {
            settings.real_estate_second_mortgage_value.show();
            settings.real_estate_second_mortgage_value.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_second_mortgage_value.filter('input[type!="hidden"]').prop('disabled', false);
            settings.real_estate_second_mortgage_balance.show();
            settings.real_estate_second_mortgage_balance.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_second_mortgage_balance.filter('input[type!="hidden"]').prop('disabled', false);
            settings.real_estate_second_mortgage_your_name.show();
            settings.real_estate_second_mortgage_your_name.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_second_mortgage_your_name.filter('input[type!="hidden"]').prop('disabled', false);
        } else {
            settings.real_estate_second_mortgage_value.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_second_mortgage_value.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_second_mortgage_value.hide();
            settings.real_estate_second_mortgage_balance.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_second_mortgage_balance.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_second_mortgage_balance.hide();
            settings.real_estate_second_mortgage_your_name.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_second_mortgage_your_name.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_second_mortgage_your_name.hide();
            settings.real_estate_second_mortgage_percent.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_second_mortgage_percent.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_second_mortgage_percent.hide();
        }

        settings.second_mortgage_in_name.click(function() {
            checkSecondMortgage();
        });
        checkSecondMortgageInName();
    };

    var checkSecondMortgageInName = function () {
        if (settings.second_mortgage_in_name.filter(':checked').val() == 'yes' && settings.second_mortgage.filter(':checked').val() == 'yes') {
            settings.real_estate_second_mortgage_percent.show();
            settings.real_estate_second_mortgage_percent.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_second_mortgage_percent.filter('input[type!="hidden"]').prop('disabled', false);
        } else {
            settings.real_estate_second_mortgage_percent.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_second_mortgage_percent.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_second_mortgage_percent.hide();
        }
    };

    var checkJointlyOwned = function () {
        if (settings.jointly_owned.filter(':checked').val() == 'yes') {
            settings.real_estate_jointly_owned_percent.show();
            settings.real_estate_percent_of_mortgage.show();
            settings.real_estate_percent_of_mortgage.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_percent_of_mortgage.filter('input[type!="hidden"]').prop('disabled', false);
            settings.real_estate_jointly_owned_percent.filter('input[type!="hidden"]').attr('required', 'required');
            settings.real_estate_jointly_owned_percent.filter('input[type!="hidden"]').prop('disabled', false);
        } else {
            settings.real_estate_jointly_owned_percent.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_jointly_owned_percent.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_percent_of_mortgage.filter('input[type!="hidden"]').removeAttr('required');
            settings.real_estate_percent_of_mortgage.filter('input[type!="hidden"]').prop('disabled', true);
            settings.real_estate_percent_of_mortgage.hide();
            settings.real_estate_jointly_owned_percent.hide();
        }
    };

    return {
        initialize: function(id, qp_id_for_has_real_estate_type, real_estate_type, index, qp_id_for_real_estate_type) {
            settings.set_id = $('#' + id);
            settings.real_estate_type_id = $(qp_id_for_has_real_estate_type);
            settings.real_estate_type = $(real_estate_type);

            settings.rent_income = $("input[name='answers[" + qp_id_for_real_estate_type + "][" + index + "][13][value]']");
            settings.real_estate_rent_income_value = $("#answers_real_estate_rent_income_value_" + index);

            settings.second_mortgage = $("input[name='answers[" + qp_id_for_real_estate_type + "][" + index + "][8][value]']");
            settings.real_estate_second_mortgage_value = $("#answers_real_estate_second_mortgage_value_" + index);

            settings.second_mortgage_in_name = $("input[name='answers[" + qp_id_for_real_estate_type + "][" + index + "][10][value]']");
            settings.real_estate_second_mortgage_balance = $("#answers_real_estate_second_mortgage_balance_" + index);
            settings.real_estate_second_mortgage_your_name = $("#answers_real_estate_second_mortgage_your_name_" + index);
            settings.real_estate_second_mortgage_percent = $("#answers_real_estate_second_mortgage_percent_" + index);

            settings.jointly_owned = $("input[name='answers[" + qp_id_for_real_estate_type + "][" + index + "][2][value]']");
            settings.real_estate_jointly_owned_percent = $("#answers_real_estate_jointly_owned_percent_" + index);
            settings.real_estate_percent_of_mortgage = $("#answers_real_estate_percent_of_mortgage_" + index);

            this.bindUIActions();
        },
        bindUIActions: function() {
            settings.rent_income.click(function() {
                checkRentIncome();
            });
            checkRentIncome();

            settings.second_mortgage.click(function() {
                checkSecondMortgage();
            });
            checkSecondMortgage();

            settings.second_mortgage_in_name.click(function() {
                checkSecondMortgage();
            });
            checkSecondMortgageInName();

            settings.jointly_owned.click(function() {
                checkJointlyOwned();
            });
            checkJointlyOwned();

            $("input[name='answers[" + this.real_estate_type_id + "][value]']").click(function() {
                checkIt();
            });
        }
    }

});