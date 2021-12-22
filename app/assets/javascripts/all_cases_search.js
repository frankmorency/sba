var removePillBreadCrumb = function(elm) {
  var elmID = elm.parentElement.id.replace("pill-", "");
  elmID = elmID.replace(/\s+/g, '-');
  $(".check-pill input[id='"+elmID+"']").prop( "checked", false );
  var inputElm = document.getElementById(elmID);
  sendAllSearchRequest(inputElm);
  $(elm).parent().remove();
}

var facetLabelUnCheckAll = function(elm) {
  var value = elm.attributes["for"].value;
  var facetInput = document.getElementById(elm.attributes["for"].value);
  // input is backwards/delayed checked true means turning off check
  if (facetInput.checked === true)
  {
    $(elm).parent().find("ul.check-pill input:checked").each(function() {
      $( this ).click();
    });
  }
}

var removePillForSelectCaseOwner = function(elm, type) {
  if(!type.id) {
    $("#"+type).val("");
  } else {
    type.value = "";
  }
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var removePillForSelectCurrentReviewer = function(elm, type) {
  if(!type.id) {
    $("#"+type).val("");
  } else {
    type.value = "";
  }
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var removePillForSelectOffice = function(elm) {
  var elmID = elm.parentElement.id.replace("pill-", "");
  $("select[id='"+elmID+"']").val("All offices");
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var removePillForSelectSort= function(elm) {
  var elmID = elm.parentElement.id.replace("pill-", "");
  $("select[id='"+elmID+"']").val("");
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var removePillForSearch = function(elm) {
  $("#search-field-big").val("");
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var removePillForBOS = function(elm) {
  $("#eight_a_service_bos").val("");
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var selectACSSendRequestSort = function(elm, type) {
  var elmValue = elm.value;
  var elmId = elm.id;
  sendAllSearchRequest(elm);
}

var removeSubmitStartDateRange = function(elm) {
  $("#eight_a_start_date").val('');
  $("#eight_a_end_date").val('');
  sendAllSearchRequest();
  $(elm).parent().remove();
}

var submitStartDateRange = function(elm, type) {
  var startDate = $("#"+type+"_start_date").val();
  var endDate = $("#"+type+"_end_date").val();
  $("#pill-start_date").remove();
  if(!startDate && !endDate) {
    return

  }
  else if (!startDate) {
    $('#start_date_error').removeClass('hidden');
    return
  }

  if(!endDate && startDate){
    var dateRange = startDate;
  } else {
    var dateRange = startDate + endDate;
    if(!dateRange || !endDate || !startDate || Date.parse(startDate) > Date.parse(endDate)) {
      $('#start_date_error').removeClass('hidden');
      return;
    }
  }
  $('#start_date_error').addClass('hidden');
  sendAllSearchRequest(elm);
  var bluePill = "<div id='pill-start_date' class='sba-c-facet-pill'>Date - start date <button class='sba-c-facet-pill__close-button' onclick='removeSubmitStartDateRange("+'this'+")' title='Close'>X</button></div>";
  $("#case-breadcrumb-pills").append(bluePill);
}

var selectACSSendRequestSBAOffice = function(elm) {
  var elmValue = elm.value;
  var elmId = elm.id;
  $("#pill-eight_a_sba_office").remove();
  sendAllSearchRequest(elm);
  var bluePill = "<div id='pill-"+elmId+"' class='sba-c-facet-pill'>SBA Office - "+elmValue+"<button class='sba-c-facet-pill__close-button' onclick='removePillForSelectOffice("+'this'+")' title='Close'>X</button></div>";
  $("#case-breadcrumb-pills").append(bluePill);
}

var sendAllSearchRequestSearchField = function(elm, type) {
  checkCaseOwnership("eight_a_case_owner");
  checkBOS();
  submitStartDateRange(elm, 'eight_a');
  sendAllSearchRequest(elm);
}

var sendAllSearchRequestSearchFieldMPP = function(elm) {
  checkCaseOwnership("mpp_case_owner");
  sendAllSearchRequest(elm);
}

var sendAllSearchRequestSearchFieldWOSB = function(elm) {
  checkCaseOwnership("wosb_case_owner");
  sendAllSearchRequest(elm);
}

var sendAllSearchRequestSearchFieldWOSBreviewer = function(elm) {
  checkCurrentReviewer("wosb_current_reviewer");
  sendAllSearchRequest(elm);
}

var checkMainSearch = function(type) {
}

var checkCaseOwnership = function(type) {
  var caseOwnershipInput = document.getElementById(type);
  var elmValue = caseOwnershipInput.value;
  var elmId = type;
  if(!caseOwnershipInput.value) {
    $("#pill-"+elmId+"").remove();
    return;
  }
  $("#pill-"+elmId+"").remove();
  var bluePill = "<div id='pill-"+elmId+"' class='sba-c-facet-pill'>Case Owner - "+elmValue+"<button class='sba-c-facet-pill__close-button' onclick='removePillForSelectCaseOwner("+'this'+', '+type+")' title='Close'>X</button></div>";
  $("#case-breadcrumb-pills").append(bluePill);
}

var checkCurrentReviewer = function(type) {
  var currentReviewerInput = document.getElementById(type);
  var elmValue = currentReviewerInput.value;
  var elmId = type;
  if(!currentReviewerInput.value) {
    $("#pill-"+elmId+"").remove();
    return;
  }
  $("#pill-"+elmId+"").remove();
  var bluePill = "<div id='pill-"+elmId+"' class='sba-c-facet-pill'>Current Reviewer - "+elmValue+"<button class='sba-c-facet-pill__close-button' onclick='removePillForSelectCurrentReviewer("+'this'+', '+type+")' title='Close'>X</button></div>";
  $("#case-breadcrumb-pills").append(bluePill);
}

var checkBOS = function() {
  var elmInput = document.getElementById("eight_a_service_bos");
  var elmValue = elmInput.value;
  var elmId = "eight_a_service_bos";
  if(!elmValue) {
    $("#pill-eight_a_service_bos").remove();
    return;
  }
  $("#pill-eight_a_service_bos").remove();
  var bluePill = "<div id='pill-"+elmId+"' class='sba-c-facet-pill'>BOS - "+elmValue+"<button class='sba-c-facet-pill__close-button' onclick='removePillForBOS("+'this'+")' title='Close'>X</button></div>";
  $("#case-breadcrumb-pills").append(bluePill);
}

var sendAllSearchRequest = function(elm) {
  var form = $("form#case-search").serialize();
  $.ajax({
      url: '/sba_analyst/cases/all_cases_search',
      type: "POST",
      data: form
  })
  .then(function (x){
    history.pushState(null, null, window.location.origin + window.location.pathname+'?'+form);
    if($(".sba-c-facet-pill__close-button").length === 0) {
      $("#clear_all").addClass('hidden');
    } else {
      $("#clear_all").removeClass('hidden');
    }
  });
}
// case-breadcrumb-pills
$(document).ready(function() {
  // Check if it's a case-search page
  if( $("#case-search").length > 0 ) {
    $('#search-field-big, #mpp_case_owner, #eight_a_case_owner, #eight_a_service_bos, #wosb_case_owner').keypress(function (e) {
      if (e.which == 13) {
        var pageType = $(".full-grey")[0].id;
        if(pageType == "eight_a") {
          sendAllSearchRequestSearchField(this);
        }
        else if(pageType == "mpp") {
          sendAllSearchRequestSearchFieldMPP(this);
        }else if(pageType == "wosb") {
          sendAllSearchRequestSearchFieldWOSB(this);
        }
        return false;
      }
    });

    $(".check-pill input").click(function() {
      var pageType = $(".full-grey")[0].id;
      if(pageType == "eight_a") {
        sendAllSearchRequestSearchField(this);
      }
      else if(pageType == "mpp") {
        sendAllSearchRequestSearchFieldMPP(this);
      }else if(pageType == "wosb") {
        sendAllSearchRequestSearchFieldWOSB(this);
      }

      // sendAllSearchRequest(this);
      var clickedId = this.id;
      // ADD or Remove Pill BreadCrumbs
      if(this.checked === true) {
        var clickedValue = this.value;

        if( clickedValue === 'ar_early_graduation_recommended' || clickedValue === 'ar_termination_recommended' || clickedValue === 'ar_voluntary_withdrawal_recommended') {
          var slicedName = clickedValue.slice(3, clickedValue.length)
          clickedValue =  "Adverse Action - " + slicedName;
        }
        else if(this.value[0] + this.value[1] === "ar") {
          var slicedName = clickedValue.slice(3, clickedValue.length)
          clickedValue =  "Annual Review - " + slicedName;
        }
        else if(this.value[0] + this.value[1] === "ia") {
          var slicedName = clickedValue.slice(3, clickedValue.length)
          clickedValue = "Inital Application - " + slicedName;
        }
        else if(this.value[0] + this.value[1] === "cs") {
          var slicedName = clickedValue.slice(3, clickedValue.length)
          clickedValue = "Certificate Status - " + slicedName;
        }
        var bluePill = "<div id='pill-"+clickedId+"' class='sba-c-facet-pill'>"+clickedValue+"<button class='sba-c-facet-pill__close-button' onclick='removePillBreadCrumb("+'this'+")' title='Close'>X</button></div>";
        $("#case-breadcrumb-pills").append(bluePill);
      }
      else {
        $("#pill-"+this.id).remove();
      }
    });
  }
});
