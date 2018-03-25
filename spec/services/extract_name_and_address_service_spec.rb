require 'rails_helper'

RSpec.describe ExtractNameAndAddressService, type: :service do
  let(:address_text) { "John Doe Franciszka Kniaźnina 12 Kraków" }

  describe 'call' do
    it 'creates hash with extracted fullname and address' do
      expect(ExtractNameAndAddressService.new(text: address_text).call).to eq({ full_name: "John Doe", address: "Franciszka Kniaźnina 12 Kraków" })
    end

    it 'creates empty hash if empty string' do
      expect(ExtractNameAndAddressService.new(text: '').call).to eq({ full_name: '', address: '' })
    end
  end
end
