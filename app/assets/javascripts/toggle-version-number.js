// Toggles the version number on the bottom of page
// Use ctrl+? to see the version number


$(document).ready(function() {
  function checkVersion(e) {

      // this would test for ctrl+?
      if (e.ctrlKey && e.keyCode == 191) {
        var version_div = $("#version_info");
        var version_div_hidden = version_div.attr('hidden');

        //Toggle visisbility
        if (typeof version_div_hidden !== typeof undefined && version_div_hidden !== false) {
          version_div.removeAttr("hidden");
        }
        else {
          version_div.attr('hidden', '');
        }
      }
  }
  // register the handler
  document.addEventListener('keyup', checkVersion, false);
});
