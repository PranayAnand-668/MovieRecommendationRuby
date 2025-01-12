require 'net/http'
require 'json'

class TmdbService
  BASE_URL = "https://api.themoviedb.org/3"

  def initialize
    @api_key = ENV['TMDB_API_KEY']
    @bearer_token = ENV['TMDB_BEARER_TOKEN']
  end

  def fetch_movies
    url = URI("#{BASE_URL}/movie/now_playing?api_key=#{@api_key}&language=en-US&page=1")
    response = Net::HTTP.get(url)
    JSON.parse(response)['results']
  end

  def fetch_movie_details(title)
    url = URI("#{BASE_URL}/search/movie?query=#{title}&api_key=#{@api_key}")
    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{@bearer_token}" # Add the Authorization header

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    # Parse the JSON response
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['results'].first
    else
      Rails.logger.error("Failed to fetch movies: #{response.message}")
      []
    end
  end

end
