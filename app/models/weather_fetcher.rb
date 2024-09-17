# frozen_string_literal: true

# Input a lat and lon, return weather information
class WeatherFetcher
  include OpenWeatherAdapter

  attr_accessor :lat, :lon

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def url
    "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&units=#{units}&appid=#{api_key}"
  end

  # @return [Float] The current temperature
  def temp
    response.dig("main", "temp")
  end

  # @return [Float] The maximum temperature
  def max_temp
    response.dig("main", "temp_max")
  end

  # @return [Float] The minimum temperature
  def min_temp
    response.dig("main", "temp_min")
  end
 
  # Cache key for this particular lat/lon weather lookup
  #
  # @return [String] Cache key used to lookup weather in redis
  def cache_key
    "weather/#{lat}/#{lon}"
  end

  private

  # Unit of measurement. standard, imperial, or metric
  #
  # @return [String] Unit of measurement for the request. Only "imperial" for now
  def units
    "imperial"
  end

  # Fetches, parses, and returns the response.
  #
  # @return [Hash] The geocoded response, pulled from cache when possible
  def response
    return @response if defined?(@response)

    @response = JSON.parse(HTTP.get(url).body.to_s)
  end
end
