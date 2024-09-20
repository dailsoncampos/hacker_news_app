class Comment < ApplicationRecord
  belongs_to :story

  validates :hacker_news_id, presence: true, uniqueness: true
  validates :author, presence: true
  validates :text, presence: true, length: { minimum: 20 }
end
