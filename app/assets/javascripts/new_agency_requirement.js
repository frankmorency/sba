var submitNAICS = function(elm) {  
	$("#size_standard_holder").empty();
	var NaicsId = document.getElementById("add_naics").value;
	 $.ajax({
	 		type: "GET",
	    url: '/sba_analyst/agency_requirements/get_agency_naics?agency_naics=' + NaicsId
	  })
	  .then(function (x){ 
	  	if(x.name == "No Valid NAICS Entered") {
	  		$("#size_standard_holder").append("<p class='error'>NAICS code is not valid.</p>");	  		
	  	} else {
	  		$("#size_standard_holder").append("<p>"+ x.size+"</p>");
	  		document.getElementById("agency_requirement_agency_naics_code_id").value = x.id;
	  	}	  			
	  });		
}

$(document).ready(function() {  


	$.validator.addMethod('positiveNumber', function (value, element) {     	
  	return this.optional(element) || /^\+?[0-9]*\.?[0-9]+$/.test(value)
  }, 'Enter a positive number.');

	$.validator.addMethod("zipcodeUS", function(value, element) {
	    return this.optional(element) || /\d{5}-\d{4}$|^\d{5}$/.test(value)
	}, "The specified US ZIP Code is invalid");
		  
	$.validator.addMethod("phoneUS", function (phone_number, element) {
	    phone_number = phone_number.replace(/\s+/g, "");
	    return this.optional(element) || phone_number.length > 9 && phone_number.match(/^(\+?1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
	}, "Please specify a valid phone number");

	if( $("form#new_agency_requirement").length > 0 ) {

    $("#add_naics").keyup(function() {
        var maxChars = 6;
        if ($(this).val().length > maxChars) {
            $(this).val($(this).val().substr(0, maxChars));                                    
        }        
        if ($(this).val().length == maxChars) {
          $("#add_naics_button").attr("disabled", false)
        } else {
          $("#add_naics_button").attr("disabled", "disabled")
        }
    });

    $( "#agency_requirement_agency_office_id" ).combobox({      
    });

	  $("form#new_agency_requirement").validate({
		
			rules: {
				"agency_requirement[title]": {
				  required: true
				},
				"agency_requirement[agency_contract_type_id]": {
					required: true
				},
				"agency_requirement[agency_office_id]": {
					required: true
				},			
				"combobox_agency_requirement[agency_office_id]": {
					required: true
				},				
				"agency_co[email]": {
					email: true
				},				
				"agency_co[phone]": {
					phoneUS: true
				},				
				"agency_co[zip]": {
					zipcodeUS: true
				},
				"agency_requirement[estimated_contract_value]": {
					number: true,
					positiveNumber: true
				},
				"agency_requirement[contract_value]": {
					number: true,
					positiveNumber: true
				},									
				"add_naics": {
					number: true
				}					
			},	 

	    errorPlacement: function(label, element) {    		    
	    	$("label[for="+element[0].id+"]").append(label);				
	    }
   	    
	  });    
	}
});
