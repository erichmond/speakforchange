
var currentMarker;
var currentZipcode;

function createMarker(point, zipcode) {
  var marker = new GMarker(point);
  GEvent.addListener(marker, "click", function() {
    // not using this yet  
    currentMarker = this;
    currentZipcode = zipcode;

    /* NEW implementation: do ajax call to zipcodes/x and load the content in a

    var url = "/zipcodes/" + zipcode + " #messagesCollection";
    $('#messagesCollection').load( url, function() {

      $(document).ready(function() {

      pagePlayer.initDOM();
      setAutoplay();

      });


    } );

    */
    $('#showAllLink').show();
    $('.message').hide();
    $(".zipcode_" + zipcode).show();
    
    var audio_link = $(".zipcode_" + zipcode + " a.audio:first")[0];
    pagePlayer.handleClick({target: audio_link});
    // this.setImage("http://labs.google.com/ridefinder/images/mm_20_yellow.png");

  });
  return marker;
}

// For home/index
function initializeBigMap() {

  if (zipcodes != 'undefined') {
    
    var map = new google.maps.Map2(document.getElementById("bigMap"));
    map.addControl(new GLargeMapControl()); ///setUIToDefault();
    //map.setUIToDefault();


    //map.addControl(new google.maps.LargeMapControl());
    var zoom = 4;
    // center of US  Latitude = 38.8226, Longitude = -96.1523 
    // center of all usa  53.3309, Longitude = -111.7969
    var centerLat = 38.82; 
    var centerLng = -98.00; 

    for (var i = 0; i < zipcodes.length; i++) { 

      var zipcode = zipcodes[i];
      var latlng = new GLatLng(zipcode[1], zipcode[2]);
      var marker = createMarker(latlng, zipcode[0]); 
      map.addOverlay(marker);

    }

    map.setCenter( new google.maps.LatLng(centerLat, centerLng) , zoom);

  }
}

jQuery(document).ready(function() {

//  $('.message').hide();

});

google.load("maps", "2");
google.setOnLoadCallback(initializeBigMap);

