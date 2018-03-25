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
    if address_builder.nil?
      render json: { error_message: 'No data found.' }, status: 404 and return
    end

    render json: address_builder
  rescue StandardError => e
    render json: { error_message: e }, status: 400
  end
end
