require 'rails_helper'

RSpec.describe DollcostAverageBot, type: :model do
  using RSpec::Parameterized::TableSyntax

  let!(:cp) { create(:currency_pair) }
  let!(:user) { create(:user) }

  describe `#needs_to_order?` do
    context 'Sometime rate change from 4,000,000 JPY into some value' do
      where(:rate_move, :difference_time, :current_rate, :be_truthy?) do
        -0.011_575 | 1.day  | 3_998_999 | be_truthy # 0.011_575 * 60 * 60 * 24 => 1000.08
        -0.011_575 | 1.day  | 3_999_000 | be_falsey
        -0.011_575 | 1.hour | 3_998_999 | be_falsey
        -0.011_575 | 2.day  | 3_997_999 | be_truthy
        -0.011_575 | 2.day  | 3_998_000 | be_falsey
      end

      with_them do
        it 'needs to order untill breakout' do
          base = Time.zone.local(2018, 11, 12, 13, 14, 15)
          tsb = nil

          travel_to(base) do
            tsb = DollcostAverageBot.create!(
              currency_pair_id: cp.id,
              level_base: 4_000_000,
              level_slope: rate_move,
              dca_interval_unit: :day,
              dca_interval_value: 1,
              dca_settlment_amount: 500,
              user: user
            )
          end

          travel_to(base + difference_time) do
            expect(tsb.needs_to_order?(current_rate)).to be_truthy?
          end
        end
      end
    end

    context 'Some interval given and some duration elapesed without breakout' do
      where(:interval_value, :interval_unit, :difference_time, :be_truthy?) do
        1 | :day    | 23.hours + 59.minutes   | be_falsey
        1 | :day    | 24.hours                | be_truthy
        1 | :day    | 48.hours                | be_truthy

        3 | :day    | 2.days + 23.hours       | be_falsey
        3 | :day    | 3.days                  | be_truthy
        3 | :day    | 4.days                  | be_truthy

        1 | :hour   | 59.minutes + 59.seconds | be_falsey
        1 | :hour   | 60.minutes              | be_truthy
        1 | :hour   | 120.minutes             | be_truthy

        3 | :hour   | 2.hours + 59.minutes   | be_falsey
        3 | :hour   | 3.hours                | be_truthy
        3 | :hour   | 4.hours                | be_truthy

        1 | :minute | 59.seconds              | be_falsey
        1 | :minute | 60.seconds              | be_truthy
        1 | :minute | 120.seconds             | be_truthy

        3 | :minute | 2.minutes + 59.seconds | be_falsey
        3 | :minute | 3.minutes              | be_truthy
        3 | :minute | 4.minutes              | be_truthy
      end

      with_them do
        it 'returns true if across a period' do
          base = Time.zone.local(2018, 11, 12, 0, 0, 0)
          tsb = nil

          travel_to(base) do
            tsb = DollcostAverageBot.create!(
              currency_pair_id: cp.id,
              level_base: 4_000_000,
              level_slope: -0.010_000,
              dca_interval_unit: interval_unit.to_s,
              dca_interval_value: interval_value,
              dca_settlment_amount: 500,
              user: user
            )
          end

          travel_to(base + difference_time) do
            expect(tsb.needs_to_order?(2_000_000)).to be_truthy?
          end
        end
      end
    end
  end

  describe '#order' do
    ODERS_URL = 'https://coincheck.com/api/exchange/orders'.freeze

    it 'sends a buy request' do
      stub = stub_request(:post, ODERS_URL).to_return(status: 200, body: { success: true }.to_json)

      bot = DollcostAverageBot.create!(
        currency_pair_id: cp.id,
        level_base: 4_000_000,
        level_slope: -100,
        dca_interval_unit: :day,
        dca_interval_value: 1,
        dca_settlment_amount: 5000,
        user: user
      )
      bot.order('jobjobjob', Time.zone.local(2018, 11, 12, 13, 14, 15))

      expect(stub).to have_been_requested.once
    end

    it 'sends idempotent request with equivalancy of nonce' do
      stub = stub_request(:post, ODERS_URL).to_return(status: 200, body: { success: true }.to_json)
      bot = create(:dollcost_average_bot, currency_pair_id: cp.id, user: user)
      base = Time.zone.local(2018, 11, 12, 0, 0, 0)
      request = nil

      bot.order('jobjobjob', base)

      request_save_proc =
        proc do |req|
          request = req
          true
        end

      expect(stub).to have_requested(:post, ODERS_URL).with(&request_save_proc).once

      bot.order('jobjobjob', base + 30.seconds)

      request_compare_proc = proc { |req| request == req }
      expect(stub).to have_requested(:post, ODERS_URL).with(&request_compare_proc).once
    end
  end
end
