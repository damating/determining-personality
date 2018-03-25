require 'rails_helper'

RSpec.describe NameApi::Client do
  let(:json_success_result) do
    "{\n  \"matches\" : [ {\n    \"parsedPerson\" : {\n      \"personType\" : \"NATURAL\",\n      \"personRole\" : \"PRIMARY\",\n      \"mailingPersonRoles\" : [ \"ADDRESSEE\" ],\n      \"gender\" : {\n        \"gender\" : \"MALE\",\n        \"confidence\" : 0.9316239316239318\n      },\n      \"addressingGivenName\" : \"John\",\n      \"addressingSurname\" : \"Doe\",\n      \"outputPersonName\" : {\n        \"terms\" : [ {\n          \"string\" : \"John\",\n          \"termType\" : \"GIVENNAME\"\n        }, {\n          \"string\" : \"Doe\",\n          \"termType\" : \"SURNAME\"\n        } ]\n      }\n    },\n    \"parserDisputes\" : [ ],\n    \"likeliness\" : 0.9631244297762165,\n    \"confidence\" : 0.9283252600914175\n  }, {\n    \"parsedPerson\" : {\n      \"personType\" : \"NATURAL\",\n      \"personRole\" : \"PRIMARY\",\n      \"mailingPersonRoles\" : [ \"ADDRESSEE\" ],\n      \"gender\" : {\n        \"gender\" : \"MALE\",\n        \"confidence\" : 0.9555555555555555\n      },\n      \"addressingGivenName\" : \"John\",\n      \"addressingSurname\" : \"Doe\",\n      \"outputPersonName\" : {\n        \"terms\" : [ {\n          \"string\" : \"John\",\n          \"termType\" : \"GIVENNAME\"\n        }, {\n          \"string\" : \"Doe\",\n          \"termType\" : \"SURNAME\"\n        } ]\n      }\n    },\n    \"parserDisputes\" : [ ],\n    \"likeliness\" : 0.6090614584338334,\n    \"confidence\" : 0.6571208208048545\n  } ]\n}"
  end

  let(:json_result_with_likeliness_under_norm) do
    "{\n  \"matches\" : [ {\n    \"parsedPerson\" : {\n      \"personType\" : \"NATURAL\",\n      \"personRole\" : \"PRIMARY\",\n      \"mailingPersonRoles\" : [ \"ADDRESSEE\" ],\n      \"gender\" : {\n        \"gender\" : \"MALE\",\n        \"confidence\" : 0.5316239316239318\n      },\n      \"addressingGivenName\" : \"John\",\n      \"addressingSurname\" : \"Doe\",\n      \"outputPersonName\" : {\n        \"terms\" : [ {\n          \"string\" : \"John\",\n          \"termType\" : \"GIVENNAME\"\n        }, {\n          \"string\" : \"Doe\",\n          \"termType\" : \"SURNAME\"\n        } ]\n      }\n    },\n    \"parserDisputes\" : [ ],\n    \"likeliness\" : 0.5631244297762165,\n    \"confidence\" : 0.5283252600914175\n  }, {\n    \"parsedPerson\" : {\n      \"personType\" : \"NATURAL\",\n      \"personRole\" : \"PRIMARY\",\n      \"mailingPersonRoles\" : [ \"ADDRESSEE\" ],\n      \"gender\" : {\n        \"gender\" : \"MALE\",\n        \"confidence\" : 0.4555555555555555\n      },\n      \"addressingGivenName\" : \"John\",\n      \"addressingSurname\" : \"Doe\",\n      \"outputPersonName\" : {\n        \"terms\" : [ {\n          \"string\" : \"John\",\n          \"termType\" : \"GIVENNAME\"\n        }, {\n          \"string\" : \"Doe\",\n          \"termType\" : \"SURNAME\"\n        } ]\n      }\n    },\n    \"parserDisputes\" : [ ],\n    \"likeliness\" : 0.5090614584338334,\n    \"confidence\" : 0.5571208208048545\n  } ]\n}"
  end

  let(:parsed_success_result) do
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

  before(:each) do
    CacheStore.instance.del "John Doe"
  end

  describe '#get_person_data_by_fullname' do
    it 'returns parsed data if at least one result found' do
      allow(NameApi::Request).to receive(:get_person_data_by_fullname).and_return(json_success_result)
      expect(NameApi::Client.get_person_data_by_fullname('John Doe')).to eq(parsed_success_result)
    end

    it 'returns nil if no result found' do
      allow(NameApi::Request).to receive(:get_person_data_by_fullname).and_return(json_result_with_likeliness_under_norm)
      expect(NameApi::Client.get_person_data_by_fullname('John Doe')).to eq(nil)
    end
  end
end
