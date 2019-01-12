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
  end

  describe '#order' do
    ODERS_URL = 'https://coincheck.com/api/exchange/orders'.freeze

    it 'sends a buy request' do
      stub = stub_request(:post, ODERS_URL).to_return(status: 200, body: '"success": false')

      bot = DollcostAverageBot.create!(
        currency_pair_id: cp.id,
        level_base: 4_000_000,
        level_slope: -100,
        dca_interval_unit: :day,
        dca_interval_value: 1,
        dca_settlment_amount: 5000,
        user: user
      )

      bot.order

      expect(stub).to have_been_requested.once
    end
  end
end
