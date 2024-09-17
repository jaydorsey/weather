# frozen_string_literal: true

class TemperatureController < ApplicationController
  def index
  end

  def create
    render :create, format: :turbo_stream, local_variables: { weather:, zip_code:, cached: }
  end

  private

  attr_reader :cached

  def zip_code_param
    params.permit(:zip_code).require(:zip_code)
  end

  def zip_code
    PostalGeocoder.new(zip_code_param)
  end

  def weather
    return @weather if defined?(@weather)

    @weather = WeatherFetcher.new(zip_code.lat, zip_code.lon)
    @cached = true

    Rails.cache.fetch(@weather.cache_key) do
      @cached = false
    end
  end
end
