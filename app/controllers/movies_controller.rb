class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    # initialize session
    session[:ratings] = @all_ratings unless session[:ratings].present?
    session[:sort_title] = '0' unless session[:sort_title].present?
    session[:sort_release_data] = '0' unless session[:sort_release_date].present?
    
    # update session
    session[:ratings] = params[:ratings].keys if params[:ratings].present?
    if params[:sort_title].present?
      session[:sort_title] = '1'
      session[:sort_release_date] = '0'
    elsif params[:sort_release_date].present?
      session[:sort_title] = '0'
      session[:sort_release_date] = '1'
    end

    unless params[:ratings].present? and params[:sort_title].present? and params[:sort_release_date].present?
      params[:ratings] = Hash[session[:ratings].collect {|r| [ r, '1' ]}]
      params[:sort_title] = session[:sort_title]
      params[:sort_release_date] = session[:sort_release_date]
      redirect_to movies_path(params)
    end

    @selected_ratings = session[:ratings]
    if session[:sort_title] == '1'
      @movies = Movie.order(:title).where(:rating => session[:ratings])
      @sort = "title"
    elsif session[:sort_release_date] == '1'
      @movies = Movie.order(:release_date).where(:rating => session[:ratings])
      @sort = "release_date"
    else
      @movies = Movie.where(:rating => @selected_ratings)
      @sort = "none"
    end
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
