FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "trader#{n}@gmail.com" }
    password { 'jljljl' }
    api_key { '0123456701234567' }
    secret_key { '01234567012345670123456701234567' }
  end
end
