class BooksController < ApplicationController
    before_action :authenticate_user!
    
    def index
    end
    
    def show
     @book = Book.find(params[:id]) 
    end
    
    def new
     @book = Book.new
     @genre = @book.genre {|genre| book.genre.build}
    end
    
    def edit 
     @book = Book.find(params[:id])
    end
    
    def create 
     @book = Book.new(book_params)
     if @book.save
      flash[:success] = "Your book has been added!"
      redirect_to library_path
     else
      flash[:try_again] = "Something went wrong - please try again."
      render action: 'new'
     end
    end
    
    def borrow
     @book = Book.find(params[:id]) 
     @book.user_id = current_user.id
     @book.borrow
     flash[:success] = "Book added to your rentals!"
     redirect_to library_path(current_user.id)
    end
    
    private
    
    def book_params
      params.require(:book).permit(:title, :author, :year, :description, :genre_id)
    end
  
end
