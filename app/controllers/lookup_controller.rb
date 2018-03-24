class LookupController < ApplicationController
  before_action :authenticate

  def show
  end

  def lookup
    lookup_text = params[:lookup_text]
    if lookup_text.empty?
      render json: { error_message: 'Please provide address information.' }, status: 400 and return
    end

    address_builder = EnrichAddressService.new(plain_address_text: lookup_text).call
    render json: address_builder
  rescue StandardError => e
    render json: { error_message: e }, status: 400
  end
end
