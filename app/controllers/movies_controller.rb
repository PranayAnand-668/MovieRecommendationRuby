class MoviesController < ApplicationController
  def index
    tmdb_service = TmdbService.new
    movies = tmdb_service.fetch_movies

    @movies = movies.map do |movie|
      trailer_url = tmdb_service.fetch_trailer(movie['id']) 
      movie.merge('trailer_url' => trailer_url)            
    end
    # Rails.logger.info "Fetched Movies: #{@movies.inspect}"
    favorite_movies = FavoriteMovie.pluck(:title)

    if favorite_movies.present?
      @recommendations = fetch_user_recommendations(favorite_movies)
    end
  end

  def fetch_recommendations
    genre = params[:genre]
    actor = params[:actor]
    mood = params[:mood]
    location = fetch_user_location

    prompt = "Recommend 10 movies for a person in '#{location}', in the genre '#{genre}', starring #{actor}, with a mood of '#{mood}'."

    # Fetch the recommendations from OpenAI
    open_ai_service = OpenAiService.new
    # movie_titles = open_ai_service.fetch_movie_recommendations(prompt)

    # Fetch movie details from TMDB for each title
    movie_titles=['Batman','Mission Impossible','Titanic','Sonic','Deadpool','Avengers','Iron Man']
    tmdb_service = TmdbService.new
    @movies_details = movie_titles.map do |title|
      tmdb_service.fetch_movie_details(title)
    end

    # Rails.logger.info "Fetched Movies: #{@movies_details.inspect}"
    # Render the new view
    render :recommendations
  end

  def store_movie
    movie_title = params[:title]
    trailer_url = params[:trailer_url]

    if movie_title.present?
      # Save the movie to the database
      favorite_movie = FavoriteMovie.find_or_create_by(title: movie_title)
      if favorite_movie.persisted?
        if trailer_url.present?
          redirect_to trailer_url, allow_other_host: true and return
        end
        flash[:notice] = "Movie '#{movie_title}' saved successfully!"
      else
        flash[:alert] = "Failed to save movie."
      end
    else
      flash[:alert] = "Movie title is missing."
    end
    
    # Redirect back to the index page
    redirect_to movies_path
  
  end
  

  def fetch_user_recommendations(movies_list)
    prompt = "Recommend 20 movie titles for a person who likes movies such as '#{movies_list.join(', ')}', focusing on firstly the 'genre', then the 'actors' and other similarities."

    movies_list=['titanic','mission impossible']

    # Fetch the recommendations from OpenAI
    open_ai_service = OpenAiService.new
    # movie_titles = open_ai_service.fetch_movie_recommendations(prompt)

    # Fetch movie details from TMDB for each title
    movie_titles=['Batman','Mission Impossible','Titanic','Sonic','Deadpool','Avengers','Iron Man']
    tmdb_service = TmdbService.new
    movie_titles.map do |title|
      tmdb_service.fetch_movie_details(title)
    end

    # Rails.logger.info "Fetched Movies: #{@movies_details.inspect}"
  end

  def truncate_favorites
    FavoriteMovie.delete_all
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='favorite_movies'")
    redirect_to root_path
  end

  private

  def fetch_user_location
    result = Geocoder.search(request.remote_ip).first
      if result
        city = result.city.presence || "India"
        state = result.state.presence || "India"
        "#{city}, #{state}" 
      else
        "Any Location"
      end
  end
end