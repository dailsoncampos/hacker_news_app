class Story < ApplicationRecord
  has_many :comments

  validates :title, :url, :hacker_news_id, presence: true
  validates :hacker_news_id, uniqueness: true
end
