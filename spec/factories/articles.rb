FactoryBot.define do
  factory :article, class: 'Article' do
<<<<<<< HEAD
    account_id { 1 }
    category_id { 1 }
    locale { 'en' }
    author_id { 1 }
    title { "#{Faker::Movie.title} #{SecureRandom.hex}" }
    content { 'MyText' }
    description { 'MyDescrption' }
    status { 1 }
=======
    account
    category { nil }
    portal
    locale { 'en' }
    association :author, factory: :user
    title { "#{Faker::Movie.title} #{SecureRandom.hex}" }
    content { 'MyText' }
    description { 'MyDescrption' }
    status { :published }
>>>>>>> upstream/develop
    views { 0 }
  end
end
