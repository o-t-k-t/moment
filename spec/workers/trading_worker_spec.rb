require 'rails_helper'
RSpec.describe TradingWorker, :vcr, type: :worker do
  describe '#performn' do
    let(:coincheck_rate) do
      VCR.use_cassette('coincheck/read_rate') { CoincheckClient.new.read_rate }
    end

    it 'fetches the URL' do
      described_class.new.perform
    end
  end
end
