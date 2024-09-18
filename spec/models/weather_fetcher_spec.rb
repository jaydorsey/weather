# frozen_string_literal: true

RSpec.describe WeatherFetcher do
  subject(:weather) { described_class.new(lat, lon) }

  let(:city) { { "zip":"23958", "name": "Prince Edward County", "lat": 37.2653, "lon": -78.6517,"country": "US" } }
  let(:forecast) { { "main":{ "temp": 68.67, "temp_min": 68.67,"temp_max": 69.31 } } }

  let(:lat) { 37.2653 }
  let(:lon) { -78.6517 }

  before do
    stub_request(:get, /openweathermap.org\/geo/).to_return_json(body: city)
    stub_request(:get, /openweathermap.org\/data/).to_return_json(body: forecast)
  end

  describe "attributes" do
    it { expect(weather.temp).to eq(68.67) }
    it { expect(weather.min_temp).to eq(68.67) }
    it { expect(weather.max_temp).to eq(69.31) }
    it { expect(weather.scale).to eq("°F") }
    it { expect(weather.cache_key).to eq("weather/#{lat}/#{lon}") }
  end
end
