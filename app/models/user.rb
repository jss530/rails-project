class User < ApplicationRecord
  has_many :books
  has_many :comments
  has_many :commented_books, through: :comments, source: :book
  has_one :library

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :omniauthable, :omniauth_providers => [:twitter], :authentication_keys => [:username]
  validates :username, uniqueness: true

   def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.username = auth.info.nickname
    user.password = Devise.friendly_token[0,20]
    end
   end

   def owned_books
     @owned_books = self.books.find_all {|book| book.owner_number == self.id}
   end

   def rented_books
    @rented_books = self.books.find_all {|book| book.rented == true && book.owner_number != self.id}
   end

   def create_library
    new_library = Library.new
    self.id = new_library.user_id
    new_library.save
   end



end
