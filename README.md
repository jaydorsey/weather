# Weather app

This sample app uses a free API key to retrieve a lat/lon (based on a ZIP code input) 
and display the current weather. It's a vanilla Rails 7 application with some very light
turbo work and some poorly done tailwind.

## Prerequisites

- A free API key from [Open Weather](https://openweathermap.org/) 
- Redis
- Ruby 3.x

## Setup

```
git clone https://github.com/jaydorsey/weather.git
cd weather
bin/setup
bin/rails dev:cache # turns on the caching

export OPEN_WEATHER_API_KEY=<your key>

bin/dev # starts the server && tailwind watch
```

## Running tests

```
bin/rspec

```

## Geocoding ZIP codes

In order to retrieve weather, we first need to geocode the ZIP code

```ruby
> city = PostalGeocoder.new('23958')
=> #<PostalGeocoder:0x0000000127ae22e8 @zip_code="23958">
> city.lat
=> 37.2653
> city.lng
=> -78.6517
```

## Retrieving weather for lat/lng

Once we retrieve a lat/lng, we can retrieve the weather for the ZIP code

```ruby
city = PostalGeocoder.new('23958')
=> #<PostalGeocoder:0x0000000127ae22e8 @zip_code="23958">
weather = WeatherFetcher.new(city.lat, city.lon)
=> #<WeatherFetcher:0x000000012863f500 @lat=37.2653, @lon=-78.6517>
weather.temp
=> 68.67
weather.max_temp
=> 69.31
weather.min_temp
=> 68.67
```

## Screenshots
![image](https://github.com/user-attachments/assets/7310d03e-bf0c-4b09-be99-d4b95f447ad8)
