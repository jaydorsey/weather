# frozen_string_literal: true

module OpenWeatherAdapter
  # Open Weather API key
  #
  # @return String the api key
  def api_key
    Rails.configuration.x.open_weather.api_key
  end

  # Static country code (US-only)
  #
  # @return String Country code as a 2 char string
  def country_code
    'US'
  end
end
