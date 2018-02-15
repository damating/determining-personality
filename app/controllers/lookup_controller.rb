class LookupController < ApplicationController
  before_action :authenticate

  def show
  end

  def lookup
    lookup_text = params[:lookup_text]

    if lookup_text.empty?
      render json: { success: 'You need to put text to the text area' } and return
    end

    address_enricher = AddressEnricher.new(lookup_text)
    address_enricher.get_result

    render json: { success: lookup_text }
  end
end
