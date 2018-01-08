require 'pry'

class LibraryController < ApplicationController
   helper_method :my_library
  
  def show
    @my_library = Library.find(params[:id])
    
    if user_signed_in? && current_user.id == @my_library.id
        @rented_books = @my_library.user.rented_books
        @owned_books = @my_library.user.owned_books
    else
        flash[:sign_in_needed] = "Please sign in."
        redirect_to root_path
    end
  end
  
end
