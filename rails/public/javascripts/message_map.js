
// For messages/show
function initializeMessage() {

  if (message_json != 'undefined') {
    
    var message = message_json;

    var map = new google.maps.Map2(document.getElementById("map"));

    //map.addControl(new google.maps.LargeMapControl());
    var zoom = 4;

    if (message.lat == null || message.lng == null) {
      zoom = 2;
      // center of US  Latitude = 38.8226, Longitude = -96.1523 
      message.lat = 38.8226;
      message.lng = -96.1523; 

    } else {

      var latlng = new GLatLng(message.lat, message.lng);
      var marker = new GMarker(latlng);
      map.addOverlay(marker);

    }
    map.setCenter( new google.maps.LatLng(message.lat, message.lng) , zoom);

  }
}

google.load("maps", "2");
google.setOnLoadCallback(initializeMessage);

jQuery(document).ready(function() {

});

