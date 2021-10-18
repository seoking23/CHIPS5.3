class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings] == nil and params[:order] == nil
      if params[:came_from_show] == "true"
        params[:ratings] = session[:ratings_to_show]
        params[:order] = session[:order_type]       
      end
    end
    @ratings_to_show = params[:ratings]
    
    session[:ratings_to_show] = @ratings_to_show

    if @ratings_to_show != nil
      if @ratings_to_show.is_a?(Hash)
        @ratings_to_show = @ratings_to_show.keys
      end
    else @ratings_to_show = @all_ratings
    end
    

    @movies = Movie.with_ratings(@ratings_to_show)
     
    @order_type = params[:order]
    
    @title_class = "p-3 mb-2"
    @release_date_class = "p-3 mb-2"
    if @order_type != nil
      @movies = @movies.order(@order_type)
      if @order_type == "title"
        @title_class = "hilite bg-warning p-3 mb-2"
        @release_date_class = "hilite p-3 mb-2"
      elsif @order_type == "release_date"
        @title_class = "hilite p-3 mb-2"
        @release_date_class ="hilite bg-warning p-3 mb-2"
      else
        @title_class = "p-3 mb-2"
        @release_date_class = "p-3 mb-2"        
      end
    
    end
    
    session[:order_type] = @order_type
    

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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :order, :home)
  end
  def movie_sessions
    session.require(:movie).permit(:order_type, :ratings_to_show)
  end
  
end
  

    
