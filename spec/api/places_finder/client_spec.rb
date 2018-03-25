require 'rails_helper'

RSpec.describe PlacesFinderApi::Client do
  let(:address_text) { 'Nopio Franciszka Kniaźnina 12 Kraków' }
  let(:fake_text) { 'Fake fake fake Kraków' }

  let(:json_success_result) do
    "{\"html_attributions\":[],\"results\":[{\"formatted_address\":\"Franciszka Kniaźnina 12/102, 31-637 Kraków, Poland\",\"geometry\":{\"location\":{\"lat\":50.09122499999999,\"lng\":19.990139},\"viewport\":{\"northeast\":{\"lat\":50.09255542989272,\"lng\":19.99149137989272},\"southwest\":{\"lat\":50.08985577010728,\"lng\":19.98879172010728}}},\"icon\":\"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png\",\"id\":\"0f5c262b3083b524a20be31a12039799956ecbf0\",\"name\":\"Nopio\",\"photos\":[{\"height\":1365,\"html_attributions\":[\"\\u003ca href=\\\"https://maps.google.com/maps/contrib/106118035468653297154/photos\\\"\\u003eNopio\\u003c/a\\u003e\"],\"photo_reference\":\"CmRaAAAA-Ln8wvwFOQdYUdPaMUXCfe3SGyofC2bqcg-J0XznF-i3w76Bj0U0ieEQtkI3N3174bZjoIkUHs439CvA2rAUD_df6EcEnFroUbEr0nVBapaFC3xBfSNQ5iV0f00vEucJEhBMM1uQqcUVSLcfWjISdVYwGhQvgkLqY3n1hRqzpxjHABtCEuw3Og\",\"width\":2048}],\"place_id\":\"ChIJm73rQLhaFkcRk-8D9uGfz_0\",\"rating\":5,\"reference\":\"CmRbAAAAEPIcWjyRPJg01RyW5u_q2JXJuIAv_BW2aAMxmqEnAZzeD4pjqBrmz648859bBBUtJs8-5bvZPdiSYq-qBsPJ0BZ3vhN408JVpIKw9PewruduYjuJkoMiUiaDj3jWFmkrEhCH1dtC12io-cnIh3-ZqED0GhRDpiOx2gsgBhTioNZE1ngy9D0Jfg\",\"types\":[\"point_of_interest\",\"establishment\"]}],\"status\":\"OK\"}"
  end

  let(:json_no_result) do
    "{\n   \"html_attributions\" : [],\n   \"results\" : [],\n   \"status\" : \"ZERO_RESULTS\"\n}\n"
  end

  let(:parsed_success_result) do
    {"formatted_address"=>"Franciszka Kniaźnina 12/102, 31-637 Kraków, Poland",
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
     "types"=>["point_of_interest", "establishment"]}
  end

  describe '#get_person_data_by_fullname' do
    it 'returns parsed data if at least one result found' do
      CacheStore.instance.del address_text
      allow(PlacesFinderApi::Request).to receive(:get_address_data).and_return(json_success_result)
      result = PlacesFinderApi::Client.get_address_data(address_text)
      expect(result['formatted_address']).to eq(parsed_success_result['formatted_address'])
      expect(result['name']).to eq(parsed_success_result['name'])
      expect(result['geometry']['location']).to eq(parsed_success_result['geometry']['location'])
      expect(result['types']).to eq(parsed_success_result['types'])
    end

    it 'returns nil if no result found' do
      CacheStore.instance.del fake_text
      allow(PlacesFinderApi::Request).to receive(:get_address_data).and_return(json_no_result)
      expect(PlacesFinderApi::Client.get_address_data(fake_text)).to eq(nil)
    end
  end
end
