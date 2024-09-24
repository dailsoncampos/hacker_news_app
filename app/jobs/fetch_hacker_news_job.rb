require 'net/http'

class FetchHackerNewsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    HackerNewsService.call
  end
end
