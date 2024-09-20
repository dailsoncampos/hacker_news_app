class StoriesController < ApplicationController
  def index
    FetchHackerNewsJob.perform_later
    @stories = Story.includes(:comments).order(created_at: :desc).limit(15)
  end

  def search
    @stories = Story.where("title ILIKE ?", "%#{params[:query]}%").limit(10)
    render :index
  end
end
