require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  describe 'GET #index' do
    let!(:stories) { create_list(:story, 5, title: "Sample Title") }

    before do
      allow(FetchHackerNewsJob).to receive(:perform_later)
      get :index, params: { query: 'Sample' }
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

    it 'displays the correct stories in the view' do
      expect(response.body).to include(story.title)
    end
  end

  describe 'GET #search' do
    let!(:stories) { create_list(:story, 5, title: "Searchable Title") }

    before do
      get :search, params: { query: 'Searchable' }
    end

    it 'assigns @stories' do
      expect(controller.instance_variable_get(:@stories)).to match_array(stories)
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
