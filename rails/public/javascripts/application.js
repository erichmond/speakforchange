
function setAutoplay() {
  var checkbox = $('input[type=checkbox][name=autoplay]');

  if (checkbox.length > 0) {
    if (checkbox.attr("checked")) {
      pagePlayer.config.playNext = true;
    
    } else {
      pagePlayer.config.playNext = false;
    };
  };

  // need to set a cookie
  
}

$(document).ready(function() {
  setAutoplay();

  $('input[type=checkbox][name=autoplay]').change(function() {
    setAutoplay();
  });
});
