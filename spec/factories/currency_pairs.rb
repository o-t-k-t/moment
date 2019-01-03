FactoryBot.define do
  factory :currency_pair do
    name { 'btc_jpy' }
    key_currency { 'btc' }
    settlement_currency { 'jpy' }
  end
end
