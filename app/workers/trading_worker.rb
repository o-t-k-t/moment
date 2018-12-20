class TradingWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  sidekiq_retries_exhausted do |msg, _ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(*_args)
    res = coincheck_client.read_rate
    rate = JSON.parse(res.body).fetch('rate')
  end

  private

  def coincheck_client
    @coincheck_client || CoincheckClient.new
  end
end
