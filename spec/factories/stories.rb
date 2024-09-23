FactoryBot.define do
  factory :story do
    title { "Sample Title" }
    url { "http://example.com" }
    hacker_news_id { SecureRandom.uuid }

    trait :with_comments do
      after(:create) do |story|
        create_list(:comment, 3, story: story)
      end
    end
  end
end
