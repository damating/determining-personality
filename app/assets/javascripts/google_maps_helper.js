var GoogleMapsHelper = new function() {
  this.initMap = function(lat, lng) {
    var newPlace = {lat: lat, lng: lng};

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 15,
      center: newPlace
    });

    var marker = new google.maps.Marker({
      position: newPlace,
      map: map
    });
  }
}
