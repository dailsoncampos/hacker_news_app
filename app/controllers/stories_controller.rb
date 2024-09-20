class StoriesController < ApplicationController
  def index
    @stories = HackerNewsService.top_stories.map do |story|
      {
        id: story["id"],
        title: story["title"],
        url: story["url"],
        comments: HackerNewsService.get_comments(story)
      }
    end
  end

  def search
    @keyword = params[:keyword]
    @stories = HackerNewsService.search(@keyword)
  end
end
