require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe TradingWorker, :vcr, type: :worker do
  using RSpec::Parameterized::TableSyntax

  describe '#performn' do
    it 'fetches the URL' do
      VCR.use_cassette('get_rate_btc_jpy', erb: { rate: '11111111' }) do
        described_class.new.perform
      end
    end

    context 'Some interval given and some duration elapesed without breakout' do
      let!(:cp) { create(:currency_pair) }
      let!(:user) { create(:user) }

      where(:runnings, :pendings, :orders) do
        0 | 0 | 0
        1 | 0 | 1
        0 | 1 | 0
        1 | 1 | 1
        5 | 0 | 5
        0 | 5 | 0
        5 | 5 | 5
      end

      with_them do
        it 'kicks order to running bots' do
          travel_to(Time.zone.local(2018, 11, 10, 0, 0, 0)) do
            runnings.times { create(:dollcost_average_bot, :every_minute, user: user, currency_pair: cp) }
            pendings.times { create(:dollcost_average_bot, :daily, user: user, currency_pair: cp) }
          end

          travel_to(Time.zone.local(2018, 11, 10, 0, 1, 1)) do
            VCR.use_cassette('get_rate_btc_jpy', erb: { rate: '3000000' }) do
              expect { described_class.new.perform }.to change { OrderWorker.jobs.size }.by(orders)
            end
          end
        end
      end
    end
  end
end
