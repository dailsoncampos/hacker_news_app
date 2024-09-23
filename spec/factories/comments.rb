FactoryBot.define do
  factory :comment do
    author { "Author Name" }
    text { "Este é um exemplo de comentário com mais de vinte palavras para satisfazer os requisitos de validação." }
    hacker_news_id { SecureRandom.uuid }
    story
  end
end
