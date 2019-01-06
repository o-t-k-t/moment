cp = CurrencyPair.create!(
  name: 'btcjpy',
  key_currency: 'btc',
  settlement_currency: 'jpy'
)

u = User.create!(email: 'm@gmail.com', password: 'llllll')
DollcostAverageBot.create!(
  currency_pair_id: cp.id,
  start_at: Time.zone.now,
  level_base: 4_000_000,
  level_slope: -0.011_575,
  dca_interval_day: 1,
  dca_interval_hour: 0,
  dca_interval_minute: 0,
  dca_settlment_amount: 500,
  user_id: u.id
)

TrailingStopBot.create(
  currency_pair_id: cp.id,
  start_at: Time.zone.now,
  level_base: 4_000_000,
  level_slope: 0.011_575,
  ts_key_amount: 0.004,
  user_id: u.id
)

30.times do
  u = User.create!(email: Faker::Internet.email, password: 'llllll')
  if [true, false].sample
    DollcostAverageBot.create!(
      currency_pair_id: cp.id,
      start_at: Time.zone.now,
      level_base: 4_000_000,
      level_slope: -0.011_575,
      dca_interval_day: 1,
      dca_interval_hour: 0,
      dca_interval_minute: 0,
      dca_settlment_amount: 500,
      user_id: u.id
    )
  end

  next if [true, false].sample

  TrailingStopBot.create(
    currency_pair_id: cp.id,
    start_at: Time.zone.now,
    level_base: 4_000_000,
    level_slope: 0.011_575,
    ts_key_amount: 0.004,
    user_id: u.id
  )
end
