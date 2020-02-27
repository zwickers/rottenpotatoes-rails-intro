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
    # if a new ordering was selected, do that one
    if params[:order]
      order_by = params[:order]
      session[:order] = params[:order]
    # otherwise do the ordering that was previously picked, by checking the cookies
    else 
      order_by = session[:order]
    end

    # use this to display all unique rating in the checkboxes in the index haml view
    @all_ratings = Movie.available_ratings

    # if different ratings were selected, do those
    if params[:ratings]
      @selected_ratings = params[:ratings].keys
      session[:selected_ratings] = @selected_ratings
    # otherwise, just filter based on the previous ratings
    else
      if session[:selected_ratings]
        @selected_ratings = session[:selected_ratings]
      # first time a user views the page
      else
        @selected_ratings = []
      end
    end
    @movies = Movie.with_ratings(@selected_ratings).order(order_by)
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
