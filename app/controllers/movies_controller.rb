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
    sorted = params[:sortby]
    certain_ratings = params[:ratings]
    if sorted == 'title'
      @movies = Movie.all.order(:title)
      @title = "hilite" 
    elsif sorted == 'date'
      @movies = Movie.all.order(:release_date)
      @release = "hilite"
    elsif !certain_ratings.nil?
      @movies = Movie.where(rating: certain_ratings.keys)
    else 
      @movies = Movie.all
    end
    
    @all_ratings = ['G','PG','PG-13','R', 'NC-17']
    if !params[:ratings].nil?
      @checked_ratings = certain_ratings.keys
    else 
      @checked_ratings = @all_ratings
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
