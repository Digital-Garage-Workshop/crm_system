FactoryBot.define do
  factory :category, class: 'Category' do
<<<<<<< HEAD
    portal { portal }
    name { 'MyString' }
    description { 'MyText' }
    position { 1 }
=======
    portal
    name { 'MyString' }
    description { 'MyText' }
    position { 1 }
    slug { name.parameterize }
>>>>>>> upstream/develop

    after(:build) do |category|
      category.account ||= category.portal.account
    end
  end
end
