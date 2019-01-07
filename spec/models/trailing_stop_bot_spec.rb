require 'rails_helper'

RSpec.describe TrailingStopBot, type: :model do
  using RSpec::Parameterized::TableSyntax

  describe `#needs_to_order?` do
    context 'Sometime rate change into some value' do
      where(:rate_move, :difference_time, :current_rate, :be_truthy?) do
        0.011_575 | 1.day | 4_001_001 | be_falsey # 0.011_575 * 60 * 60 * 24 => 1000.08
        0.011_575 | 1.day | 4_001_000 | be_truthy
        0.011_575 | 2.day | 4_002_001 | be_falsey
        0.011_575 | 2.day | 4_002_000 | be_truthy
      end

      with_them do
        let!(:cp) { create(:currency_pair) }

        it 'needs to order for breakdown' do
          base = Time.zone.local(2018, 11, 12, 13, 14, 15)
          tsb = nil

          travel_to(base) do
            tsb = TrailingStopBot.create(
              currency_pair_id: cp.id,
              level_base: 4_000_000,
              level_slope: rate_move,
              ts_key_amount: 0.004
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
