class StoriesController < ApplicationController
  def index
    FetchHackerNewsJob.perform_later
    @stories = Story.where("title ILIKE ?", "%#{params[:query]}%").page(params[:page]).per(3)
  end

  def search
    @stories = Story.where("title ILIKE ?", "%#{params[:query]}%").limit(10).page(params[:page])
    render :index
  end
end
