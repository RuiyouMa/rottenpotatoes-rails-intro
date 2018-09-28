class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    # Get all movies
    @movies = Movie.all
    @all_ratings = Movie.ratings()
    @checked_ratings = @all_ratings
    @direct = 0

    # Remove based on unchecked ratings
    if !params[:ratings].nil?
      @movies = Movie.where(rating: params[:ratings].keys)
      @checked_ratings = params[:ratings].keys
      session[:ratings] = params[:ratings]
    elsif session.has_key?(:ratings)
      @movies = Movie.where(rating: session[:ratings].keys)
      @checked_ratings = session[:ratings].keys
      params[:ratings] = session[:ratings]
      @direct = 1
    end
    
    # Sort based on status
    if params.has_key?(:sortby)
      if params[:sortby] == 'title'
        @movies = @movies.order(:title)
        @sortby = 'title'
      elsif params[:sortby] == 'release_date'
        @movies = @movies.order(:release_date)
        @sortby = 'release_date'
      end
      session[:sortby] = params[:sortby]
    elsif session.has_key?(:sortby)
      if session[:sortby] == 'title'
        @movies = @movies.order(:title)
        @sortby = 'title'
      elsif session[:sortby] == 'release_date'
        @movies = @movies.order(:release_date)
        @sortby = 'release_date'
      end
      params[:sortby] = session[:sortby]
      @direct = 1
    end  
     
    # Redirect to appropriate link
    if @direct == 1
      flash.keep
      redirect_to movies_path(:sortby => params[:sortby], :ratings => params[:ratings]) 
    end

    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
