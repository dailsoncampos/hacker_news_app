require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stories_index_url
    assert_response :success
  end

  test "should get search" do
    get stories_search_url
    assert_response :success
  end
end
