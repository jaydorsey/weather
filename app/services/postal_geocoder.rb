# frozen_string_literal: true

# Input a postal code, return a lat/long
#
# Only US supported for now
class PostalGeocoder
  include OpenWeatherAdapter

  attr_accessor :cached, :zip_code

  def initialize(zip_code)
    @zip_code = zip_code
    @cached = true
  end

  def call
    validate && response
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

  def properly_formatted_zip_code
    @zip_code = zip_code.to_s[0..5].match?(/[0-9]{5}/)
  end

  # Checks for zip code validity. Only supports zip 5 for now
    # TODO: Custom error here, instead of string
  def validate
    raise "Missing ZIP code" if zip_code.blank?

    raise "Improperly formatted ZIP code" unless properly_formatted_zip_code
  end

  # Fetches, parses, and returns the response. Uses the default Rails cache to store results for
  # up to 30 minutes
  #
  # @return [Hash] The geocoded response, pulled from cache when possible
  def response
    return @response if defined?(@response)

    @response = Rails.cache.fetch("geocode/#{zip_code}", expires_in: 30.minutes) do
      external_geocode
    end
  end

  # Performs the actual external fetch of the geocode. Also handles flipping the flag to denote this wasn't cached
  #
  # @return [Hash] The geocoded response from 3rd party API
  def external_geocode
    @cached = false

    JSON.parse(HTTP.get(url).body.to_s)
  end
end
