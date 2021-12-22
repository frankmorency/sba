document.addEventListener(Certify.MSG.Config.load_event, bindUrlListeners);

function bindUrlListeners(){
  bindUrls();
}

// listen to clicking anchors on the page for navigation to external links
function bindUrls(){
  var anchors = document.getElementsByTagName('a');
  for (var i = anchors.length - 1; i >= 0; i--) {
    if ($(anchors[i]).parents('.message-body').length){
      anchors[i].addEventListener('click', catchUrlClick);
    }
  }
}

function catchUrlClick(event){
  event.preventDefault();
  var anchor = event.currentTarget;
  if (blank_href(anchor.href)) {
    return;
  } else if (external_href(anchor.href)) {
    confirmExternalLink(anchor.href);
  } else {
    window.open(anchor.href);
  }
}

function blank_href (href){
  return (href === "" || href === undefined || href === null);
}

function external_href (href){
  return (href.match(/sba.gov/ig) === null);
}

function confirmExternalLink(href){
  if (window.confirm("You clicked " + href + "\nConfirm leaving Certify.SBA.gov.")) {
    window.open(href);
  }
}
