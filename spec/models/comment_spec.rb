require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    it 'is not valid without text' do
      comment = build(:comment, text: nil)
      expect(comment).not_to be_valid
    end

    it 'is not valid without an author' do
      comment = build(:comment, author: nil)
      expect(comment).not_to be_valid
    end

    it 'is not valid without a story' do
      comment = build(:comment, story: nil)
      expect(comment).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a story' do
      story = create(:story)
      comment = create(:comment, story: story)

      expect(comment.story).to eq(story)
    end
  end
end
