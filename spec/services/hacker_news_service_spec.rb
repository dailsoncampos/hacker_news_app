require 'rails_helper'

RSpec.describe HackerNewsService do
  let(:top_story_ids) { [1]
  let(:valid_story_data) do
    {
      'id' => 1,
      'title' => 'Valid Story',
      'url' => 'https://example.com/story',
      'kids' => [100, 101]
    }
  end

  let(:valid_comment_data) do
    {
      'id' => 100,
      'by' => 'test_user',
      'text' => 'This is a valid comment with more than twenty words. It is a great comment for testing.'
    }
  end

  let(:short_comment_data) do
    {
      'id' => 101,
      'by' => 'test_user',
      'text' => 'Short comment.'
    }
  end

  before do
    allow(Net::HTTP).to receive(:get).and_return(
      top_story_ids.to_json,
      valid_story_data.to_json,
      valid_comment_data.to_json,
      short_comment_data.to_json
    )
  end

  describe '.call' do
    it 'creates a story and its relevant comments' do
      expect { described_class.call }.to change(Story, :count).by(1)
                                      .and change(Comment, :count).by(1)

      story = Story.last
      expect(story.title).to eq('Valid Story')
      expect(story.url).to eq('https://example.com/story')

      comment = Comment.last
      expect(comment.author).to eq('test_user')
      expect(comment.text).to include('This is a valid comment')
    end

    it 'ignores comments with fewer than 20 words' do
      described_class.call

      comments = Comment.all
      expect(comments.count).to eq(1)
      expect(comments.first.text).not_to eq('Short comment.')
    end

    it 'handles invalid JSON responses gracefully' do
      allow(Net::HTTP).to receive(:get).and_raise(JSON::ParserError)

      expect { described_class.call }.not_to raise_error
      expect(Story.count).to eq(0)
      expect(Comment.count).to eq(0)
    end
  end
end
