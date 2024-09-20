class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :story, null: false, foreign_key: true
      t.integer :hacker_news_id, null: false
      t.string :author, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
