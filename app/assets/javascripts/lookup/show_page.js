var LookupShow = new function() {
  this.lookup = function() {
    var addressInfo = $("#lookup_area").val();
    if(validateLookupArea(addressInfo)) {
      alert("Please provide address information.");
    } else {
      findAddressDetails(addressInfo);
    }
  };

  var validateLookupArea = function(addressInfo) {
    if(addressInfo === "") { return true };
    return false;
  }

  var findAddressDetails = function(addressInfo) {
    $.ajax({
      method: 'GET',
      dataType: 'JSON',
      data: { lookup_text: addressInfo },
      cache: false,
      url: '/lookup/result',
      success: function(result) {
        let latitude = result.address.latitude;
        let longitude = result.address.longitude;
        GoogleMapsHelper.initMap(latitude, longitude);

        if(result.address_type === "private") {
          $("#result_area").html(personalAddressHtml(result));
        } else {
          $("#result_area").html(companyAddressHtml(result));
        }
      },
      error: function(result) {
        $("#result_area").html(`<p>${result.responseJSON.error_message}</p>`);
      }
    });
  };

  var personalAddressHtml = function(data) {
    return (
      `<div>
        <p>Name: ${data.person.name} ${data.person.surname}</p>
        <p>Gender: ${data.person.gender.toLowerCase()}</p>
        <p>Address: ${data.address.formatted_address}</p>
        <p>Address type: ${data.address_type}</p>
      </div>`
    )
  };

  var companyAddressHtml = function(data) {
    return (
      `<div>
        <p>Address: ${data.address.formatted_address}</p>
        <p>Address type: ${data.address_type}</p>
      </div>`
    )
  };
};
