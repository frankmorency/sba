var resetSearchPills = function(elm, apiSearchEndpoint, searchFormName) {
  $(".sba-c-facet-pill").each(function() {
    $(this).remove();
  });
  $(".search-input").each(function() {
    $(this).val('');
  });
  sendAjaxSearchRequest(elm, apiSearchEndpoint, searchFormName);
  $("#search__pills__reset").addClass('hidden');
}

var removeSearchPill = function(elm, apiSearchEndpoint, searchFormName) {
  var elmID = elm.parentElement.id.replace("pill-", "");
  elmID = elmID.replace(/\s+/g, '-');
  var inputElm = document.getElementById(elmID);
  //Combobox hides the original selectbox
  if(inputElm.style.display == "none") {
    $("#combobox_"+elmID).val($("#combobox_"+elmID +" option:first").val());
  }
  $("#"+elmID).val($("#"+elmID +" option:first").val());
  sendAjaxSearchRequest(inputElm, apiSearchEndpoint, searchFormName);
  $(elm).parent().remove();
  if($(".sba-c-facet-pill__close-button").length === 0) {
    $("#search__pills__reset").addClass('hidden');
  }
}

var ajaxSearchChange = function(elm, apiSearchEndpoint, searchFormName) {
  var elemSearchId = elm.id;
  var elmValue = elm.value;
  if(elmValue == "true" || elmValue == "false"){
    elmValue = $("#"+elemSearchId+ " option:selected").text();
  }
  $("#pill-"+elemSearchId).remove();
  if(elmValue == "") {
  } else {
    var bluePill = "<div id=pill-"+elemSearchId+" class=sba-c-facet-pill>"+elmValue+"<button class=sba-c-facet-pill__close-button onclick='removeSearchPill(this, \""+ apiSearchEndpoint + "\", \""+ searchFormName + "\")' title=Close>X</button></div>";
    $("#search-breadcrumb-pills").prepend(bluePill);
    $("#search__pills__reset").removeClass('hidden');

  }
  sendAjaxSearchRequest(elm, apiSearchEndpoint, searchFormName);
}

var sendAjaxSearchRequest = function(elm, apiSearchEndpoint, searchFormName) {
  var form = $(searchFormName).serialize();
  $.ajax({
      url: apiSearchEndpoint,
      type: "POST",
      data: form
  })
  .then(function (x){
    history.pushState(null, null, window.location.origin + window.location.pathname+'?'+form);
    if($(".sba-c-facet-pill__close-button").length === 0) {
      $("#search__pills__reset").addClass('hidden');
    }
  });
}
