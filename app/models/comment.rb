class Comment < ApplicationRecord
  belongs_to :story

  validates :story, :hacker_news_id, :author, :text, presence: true
end
