require 'rails_helper'

RSpec.describe DollcostAverageBot, type: :model do
  using RSpec::Parameterized::TableSyntax

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
        let!(:cp) { create(:currency_pair) }

        it 'needs to order untill breakout' do
          base = Time.zone.local(2018, 11, 12, 13, 14, 15)
          tsb = nil

          travel_to(base) do
          tsb = DollcostAverageBot.create!(
            currency_pair_id: cp.id,
            start_at: base,
            level_base: 4_000_000,
            level_slope: rate_move,
            dca_interval_day: 1,
            dca_interval_hour: 0,
            dca_interval_minute: 0,
            dca_settlment_amount: 500
          )
          end

          travel_to(base + difference_time) do
            expect(tsb.needs_to_order?(current_rate)).to be_truthy?
          end
        end
      end
    end
  end
end
