require 'net/http'
require 'json'

class HackerNewsService
  HACKER_NEWS_TOP_STORIES_URL = 'https://hacker-news.firebaseio.com/v0/topstories.json'.freeze
  HACKER_NEWS_ITEM_URL = 'https://hacker-news.firebaseio.com/v0/item/'.freeze

  def self.call
    new.process_top_stories
  end

  def process_top_stories
    top_story_ids = fetch_top_story_ids

    top_story_ids.first(15).each do |story_id|
      story_data = fetch_story_data(story_id)
      
      next if story_data.nil? || !story_data['kids'] || story_data['kids'].empty?

      comments = fetch_relevant_comments(story_data['kids'])

      if comments.any?
        story = Story.create!(
          title: story_data['title'],
          url: story_data['url'],
          hacker_news_id: story_id
        )

        comments.each do |comment_data|
          Comment.create!(
            story: story,
            hacker_news_id: comment_data['id'],
            author: comment_data['by'],
            text: comment_data['text']
          )
        end
      end
    end
  end

  private

  def fetch_top_story_ids
    uri = URI(HACKER_NEWS_TOP_STORIES_URL)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError
    []
  end

  def fetch_story_data(story_id)
    uri = URI("#{HACKER_NEWS_ITEM_URL}#{story_id}.json")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError
    nil
  end

  def fetch_relevant_comments(comment_ids)
    comment_ids.map { |id| fetch_comment_data(id) }
               .compact  # Remove nil values
               .select { |comment| comment['text'] && comment['text'].split.size > 20 }
  end

  def fetch_comment_data(comment_id)
    uri = URI("#{HACKER_NEWS_ITEM_URL}#{comment_id}.json")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError
    nil
  end
end
