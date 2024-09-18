# frozen_string_literal: true

RSpec.describe PostalGeocoder do
  subject(:geocode) { described_class.new(zip_code) }

  let(:city) { { "zip":"23958","name":"Prince Edward County","lat":37.2653,"lon":-78.6517,"country":"US" } }

  describe "valid zip code" do
    let(:zip_code) { "12345" }

    before do
      stub_request(:get, /openweathermap.org\/geo/)
        .to_return_json(body: city)
    end

    describe "#lat" do
      it { expect(geocode.lat).to eq(37.2653) }
    end

    describe "#lon" do
      it { expect(geocode.lon).to eq(-78.6517) }

      describe "aliases" do
        it { expect(geocode.long).to eq(-78.6517) }
        it { expect(geocode.lng).to eq(-78.6517) }
      end
    end

    describe "#name" do
      it { expect(geocode.name).to eq("Prince Edward County") }
    end
  end

  describe "invalid zip codes" do
    describe "when missing" do
      let(:zip_code) { nil }

      it { expect { geocode.lat }.to raise_error(StandardError, "Missing ZIP code") }
    end

    describe "when too few numbers" do
      let(:zip_code) { "1234" }

      it { expect { geocode.lat }.to raise_error(StandardError, "Improperly formatted ZIP code") }
    end

    describe "when letters" do
      let(:zip_code) { "1234A" }

      it { expect { geocode.lat }.to raise_error(StandardError, "Improperly formatted ZIP code") }
    end
  end
end
