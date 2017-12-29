class Library < ApplicationRecord
    belongs_to :user
    has_many :books, through: :users
    
end