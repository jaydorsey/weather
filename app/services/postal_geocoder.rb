# frozen_string_literal: true

# Input a postal code, return a lat/long
#
# Only US supported for now
class PostalGeocoder
  include OpenWeatherAdapter

  attr_accessor :zip_code

  def initialize(zip_code)
    @zip_code = zip_code
  end

  def url
    "https://api.openweathermap.org/geo/1.0/zip?zip=#{zip_code},#{country_code}&appid=#{api_key}"
  end

  def lat
    response["lat"]
  end

  def lon
    response["lon"]
  end
  alias_method :long, :lon
  alias_method :lng, :lon

  private

  # Check ZIP code format. Limited to a simple 5 digit check at this time
  #
  # @return [Boolean] true if the ZIP code is properly formatted
  def properly_formatted_zip_code
    zip_code.to_s[0..5].match?(/[0-9]{5}/)
  end

  # Checks for zip code validity. Only supports zip 5 for now
    # TODO: Custom error here, instead of string
  def validate
    raise "Missing ZIP code" if zip_code.blank?

    raise "Improperly formatted ZIP code" unless properly_formatted_zip_code
  end

  # Fetches, parses, and returns the response. Uses the default Rails cache to store results for
  # up to 30 days
  #
  # @return [Hash] The geocoded response, pulled from cache when possible
  def response
    return @response if defined?(@response)

    validate

    @response = Rails.cache.fetch("geocode/#{zip_code}", expires_in: 30.days) { fetch_response }
  end

  # Performs the actual external fetch of the geocode. Also handles flipping the flag to denote this wasn't cached
  #
  # @return [Hash] The geocoded response from 3rd party API
  def fetch_response
    JSON.parse(HTTP.get(url).body.to_s)
  end
end
