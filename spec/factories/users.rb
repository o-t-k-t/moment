FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "trader#{n}@gmail.com"}
    password { 'jljljl' }
  end
end
