class Story < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :url, presence: true
  validates :hacker_news_id, presence: true, uniqueness: true
end
