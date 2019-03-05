FactoryBot.define do
  factory :dollar_cost_average_bot do
    level_base 4_000_000
    level_slope(-0.000_001)
    dca_interval_unit :day
    dca_interval_value 1
    dca_settlment_amount 500

    trait :every_minute do
      dca_interval_unit :minute
      dca_interval_value 1
    end

    trait :daily do
      dca_interval_unit :day
      dca_interval_value 1
    end
  end

  factory :trailing_stop_bot do
    level_base 4_000_000
    level_slope 100
    ts_key_amount 0.4
  end
end
