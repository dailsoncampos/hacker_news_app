class StoriesController < ApplicationController
  def index
    FetchHackerNewsJob.perform_later
    @stories = Story.all.limit(15)
  end

  def search
    @stories = Story.where("title ILIKE ?", "%#{params[:query]}%").limit(10).page(params[:page])
    render :index
  end
end
