require 'rails_helper'

RSpec.describe EnrichAddressService, type: :service do
  let(:lookup_text) { "John Doe Franciszka Kniaźnina 12 Kraków" }

  let(:person_details) do
    {
      "personType"=>"NATURAL",
      "personRole"=>"PRIMARY",
      "mailingPersonRoles"=>["ADDRESSEE"],
      "gender"=>{"gender"=>"MALE", "confidence"=>0.9316239316239318},
      "addressingGivenName"=>"John",
      "addressingSurname"=>"Doe",
      "outputPersonName"=>{"terms"=>[{"string"=>"John", "termType"=>"GIVENNAME"}, {"string"=>"Doe", "termType"=>"SURNAME"}]}
    }
  end

  let(:address_details) do
    {
      "formatted_address"=>"Franciszka Kniaźnina 12/102, 31-637 Kraków, Poland",
      "geometry"=>
       {"location"=>{"lat"=>50.09122499999999, "lng"=>19.990139},
        "viewport"=>{"northeast"=>{"lat"=>50.09255542989272, "lng"=>19.99149137989272}, "southwest"=>{"lat"=>50.08985577010728, "lng"=>19.98879172010728}}},
      "icon"=>"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png",
      "id"=>"0f5c262b3083b524a20be31a12039799956ecbf0",
      "name"=>"Nopio",
      "photos"=>
       [{"height"=>1365,
         "html_attributions"=>["<a href=\"https://maps.google.com/maps/contrib/106118035468653297154/photos\">Nopio</a>"],
         "photo_reference"=>
          "CmRaAAAAmJ0N-uz6l9r8PxURSes-GnGP3Irhlp0yU6DRThfVoTZOZXtP1d0yjy1W0zwU_LKPtqKlgUv_YBHH4nQXapvX_r12zKZKTx8mx7XrrtL3x64DUFNwtqZBP3oewpRrhfExEhDQuVvxIIACCfmVTCIjZQ4RGhSwTJOMCXXHnsBRBDVDm64JsWyI7g",
         "width"=>2048}],
      "place_id"=>"ChIJm73rQLhaFkcRk-8D9uGfz_0",
      "rating"=>5,
      "reference"=>
       "CmRbAAAAW5mr71Pakxijq5m7w-lJYJo5j8QxxN267EeXMMzDPROqxT-Ni9hJ6KqYQYQqeFq8PU6twaUfwMfJgUMgAn6fLDMS3fzIO13dCTt5-sCTgTeEC_GP5IOPRcuy1IEAGFE0EhDf7dSMSV7IfDLFpcVqgCRUGhQMQvbt2kBly2kyTlnBoGVVD57QTg",
      "types"=>["point_of_interest", "establishment"]
    }
  end

  describe 'call' do
    it 'returns private address' do
      allow(NameApi::Client).to receive(:get_person_data_by_fullname).and_return(person_details)
      allow(PlacesFinderApi::Client).to receive(:get_address_data).and_return(address_details)
      address_builder = EnrichAddressService.new(plain_address_text: lookup_text).call
      expect(address_builder.address_type).to eq('private')
      expect(address_builder.person.name).to eq(person_details["addressingGivenName"])
      expect(address_builder.person.surname).to eq(person_details["addressingSurname"])
      expect(address_builder.person.gender).to eq(person_details["gender"]["gender"])
      expect(address_builder.address.formatted_address).to eq(address_details["formatted_address"])
      expect(address_builder.address.latitude).to eq(address_details["geometry"]["location"]["lat"])
      expect(address_builder.address.longitude).to eq(address_details["geometry"]["location"]["lng"])
      expect(address_builder.address.place_name).to eq(address_details["name"])
    end

    it 'returns company address' do
      allow(NameApi::Client).to receive(:get_person_data_by_fullname).and_return(nil)
      allow(PlacesFinderApi::Client).to receive(:get_address_data).and_return(address_details)
      address_builder = EnrichAddressService.new(plain_address_text: lookup_text).call
      expect(address_builder.address_type).to eq('company')
      expect(address_builder.person).to eq(nil)
      expect(address_builder.address.formatted_address).to eq(address_details["formatted_address"])
      expect(address_builder.address.latitude).to eq(address_details["geometry"]["location"]["lat"])
      expect(address_builder.address.longitude).to eq(address_details["geometry"]["location"]["lng"])
      expect(address_builder.address.place_name).to eq(address_details["name"])
    end

    it 'returns nil if nothing found' do
      allow(NameApi::Client).to receive(:get_person_data_by_fullname).and_return(nil)
      allow(PlacesFinderApi::Client).to receive(:get_address_data).and_return(nil)
      address_builder = EnrichAddressService.new(plain_address_text: lookup_text).call
      expect(address_builder).to eq(nil)
    end
  end
end
