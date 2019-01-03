require 'rails_helper'
RSpec.describe TradingWorker, :vcr, type: :worker do
  describe '#performn' do
    it 'fetches the URL' do
      VCR.use_cassette('get_rate_btc_jpy', erb: { rate: '11111111' }) do
        described_class.new.perform
      end
    end
  end
end
