FactoryBot.define do
  factory :order_log do
    bot { "" }
    currency_pair { nil }
    job_id { 1 }
    message { "MyText" }
  end
end
