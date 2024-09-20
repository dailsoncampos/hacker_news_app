class AddHackerNewsIdToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :hacker_news_id, :integer
    add_index :stories, :hacker_news_id, unique: true
  end
end
