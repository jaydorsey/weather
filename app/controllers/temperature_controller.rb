# frozen_string_literal: true

class TemperatureController < ApplicationController
  def index; end

  def create
    if zip_code.name.present?
      render :create, format: :turbo_stream, locals: { weather:, zip_code:, cached: @cached }
    else
      render :error, format: :turbo_stream, locals: { zip_code: }
    end
  end

  private

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

    Rails.cache.fetch(@weather.cache_key, expires_in: 30.minutes) do
      @cached = false
      @weather
    end
  end
end
