class LookupController < ApplicationController
  before_action :authenticate

  def show
  end

  def lookup
    lookup_text = params[:lookup_text]

    if lookup_text.empty?
      render json: { html: '<p>You need to put text to the text area</p>' } and return
    end

    address_enricher = AddressEnricher.new.get_result(lookup_text)

    render json: {
      html:
        "<div>
          <p>#{address_enricher.person_name}</p>
          <p>#{address_enricher.person_surname}</p>
          <p>#{address_enricher.person_gender}</p>
          <p>#{address_enricher.formatted_address}</p>
          <p>#{address_enricher.latitude} #{address_enricher.longitude}</p>
          <p>#{address_enricher.place_types}</p>
        </div>"
    }
  rescue StandardError => e
    render json: { html: "<h3>#{e}</h3>" }
  end
end
