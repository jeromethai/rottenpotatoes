class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @selected_ratings = (params[:ratings].present? ? params[:ratings].keys : @all_ratings)
    if params.key?(:sort_title)
      @movies = Movie.order(:title).where(:rating => @selected_ratings)
      @sort = "title"
    elsif params.key?(:sort_release_date)
      @movies = Movie.order(:release_date).where(:rating => @selected_ratings)
      @sort = "release_date"
    else
      @movies = Movie.where(:rating => @selected_ratings)
      @sort = "none"
    end
    # @all_ratings = Movie.uniq.pluck(:rating)
    # @selected_ratings = (params[:ratings].present? ? params[:ratings].keys : @all_ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
