require 'rails_helper'

RSpec.describe FetchHackerNewsJob, type: :job do
  let(:top_story_ids) { [1, 2, 3] }
  let(:story_data) do
    {
      'title' => 'Sample Story',
      'url' => 'http://example.com',
      'kids' => [10, 11]
    }
  end
  let(:comment_data_valid) do
    {
      'id' => 10,
      'by' => 'author1',
      'text' => 'Este é um comentário válido com mais de vinte palavras: ' + 'blá ' * 20
    }
  end
  let(:comment_data_invalid) do
    {
      'id' => 11,
      'by' => 'author2',
      'text' => 'Comentário curto.'
    }
  end

  before do
    allow(Net::HTTP).to receive(:get).and_return(top_story_ids.to_json)
    allow_any_instance_of(FetchHackerNewsJob).to receive(:fetch_story_data).and_return(story_data)

    allow_any_instance_of(FetchHackerNewsJob).to receive(:fetch_comment_data)
      .with(10).and_return(comment_data_valid)
    allow_any_instance_of(FetchHackerNewsJob).to receive(:fetch_comment_data)
      .with(11).and_return(comment_data_invalid)
  end

  describe '#perform' do
    it 'fetches top stories and creates stories and comments' do
      expect { described_class.perform_now }.to change { Story.count }.by(1)
                                             .and change { Comment.count }.by(1)

      story = Story.last
      expect(story.title).to eq('Sample Story')
      expect(story.url).to eq('http://example.com')
      expect(story.hacker_news_id).to eq(1)

      comment = Comment.last
      expect(comment.story).to eq(story)
      expect(comment.author).to eq('author1')
      expect(comment.text).to eq(comment_data_valid['text'])
    end

    it 'does not create comments if there are none valid' do
      allow_any_instance_of(FetchHackerNewsJob).to receive(:fetch_comment_data)
        .with(11).and_return(comment_data_invalid)

      expect { described_class.perform_now }.to change { Story.count }.by(1)
                                             .and change { Comment.count }.by(0)
    end

    it 'handles JSON parsing errors gracefully' do
      allow_any_instance_of(FetchHackerNewsJob).to receive(:fetch_story_data)
        .and_raise(JSON::ParserError)

      expect { described_class.perform_now }.not_to raise_error
    end
  end
end
