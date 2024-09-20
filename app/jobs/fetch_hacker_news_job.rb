require 'net/http'

class FetchHackerNewsJob < ApplicationJob
  queue_as :default

  HACKER_NEWS_TOP_STORIES_URL = 'https://hacker-news.firebaseio.com/v0/topstories.json'
  HACKER_NEWS_ITEM_URL = 'https://hacker-news.firebaseio.com/v0/item/'

  def perform(*args)
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
  end

  def fetch_story_data(story_id)
    uri = URI("#{HACKER_NEWS_ITEM_URL}#{story_id}.json")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError
    nil
  end

  def fetch_relevant_comments(comment_ids)
    comments = []

    comment_ids.each do |comment_id|
      comment_data = fetch_comment_data(comment_id)

      if comment_data && comment_data['text'] && comment_data['text'].split.size > 20
        comments << comment_data
      end
    end

    comments
  end

  def fetch_comment_data(comment_id)
    uri = URI("#{HACKER_NEWS_ITEM_URL}#{comment_id}.json")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  rescue JSON::ParserError
    nil
  end
end
