class Comment < ApplicationRecord
  belongs_to :movie
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true

  validates :movie_id, uniqueness: {scope: :user_id, message: "Movie can be commented only once!"}
end
