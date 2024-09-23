require 'rails_helper'

RSpec.describe Story, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      story = build(:story)
      expect(story).to be_valid
    end

    it 'is not valid without a title' do
      story = build(:story, title: nil)
      expect(story).not_to be_valid
    end

    it 'is not valid without a url' do
      story = build(:story, url: nil)
      expect(story).not_to be_valid
    end

    it 'is not valid without a hacker_news_id' do
      story = build(:story, hacker_news_id: nil)
      expect(story).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many comments' do
      story = create(:story)
      comment1 = create(:comment, story: story)
      comment2 = create(:comment, story: story)

      expect(story.comments).to include(comment1, comment2)
    end
  end
end
