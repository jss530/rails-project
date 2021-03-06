class Book < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :genre, optional: true
  has_many :comments
  accepts_nested_attributes_for :genre

  validates :title, presence: true
  validates :author, presence: true
  has_attached_file :image, styles: { thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def available?
    if self.inventory != 0
      return true
    else
      return false
    end
  end

  def borrow
     self.inventory = self.inventory - 1
     self.rented = true
     self.save
     self.user.credits = self.user.credits - self.cost
     self.user.save
  end

  def return_book
     self.user.credits = self.user.credits + self.cost
     self.user.save
     self.inventory = self.inventory + 1
     self.user_id = self.owner_number
     self.rented = false
     self.save
  end

  def self.newest_books
    order('created_at desc').limit(5)
  end

  def newest_comment
    self.comments.order('created_at desc').limit(1)
  end

end
