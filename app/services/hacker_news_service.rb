class HackerNewsService
  BASE_URL = 'https://hacker-news.firebaseio.com/v0'.freeze

  def self.top_stories
    response = HTTP.get("#{BASE_URL}/topstories.json")
    story_ids = JSON.parse(response).first(15)
    story_ids.map { |id| get_story(id) }
  end

  def self.get_story(story_id)
    response = HTTP.get("#{BASE_URL}/item/#{story_id}.json")
    JSON.parse(response)
  end

  def self.get_comments(story)
    comment_ids = story["kids"] || []
    comment_ids.map { |id| get_comment(id) }
               .select { |comment| comment["text"] && comment["text"].split.size > 20 }
  end

  def self.get_comment(comment_id)
    response = HTTP.get("#{BASE_URL}/item/#{comment_id}.json")
    JSON.parse(response)
  end

  def self.search(keyword)
    top_stories.select { |story| story['title'].downcase.include?(keyword.downcase) }
  end
end
