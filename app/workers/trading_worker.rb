class TradingWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  sidekiq_retries_exhausted do |msg, _ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  # 現在値を取得し、注文が必要なBot数分、注文ジョブをエンキュー
  def perform(*_args)
    res = coincheck_client.read_rate
    rate = JSON.parse(res.body).fetch('rate')

    puts "hello #{jid} #{rate}"

    Bot.in_batches
       .select { |b| b.needs_to_order?(rate) }
       .each { |b| OrderWorker.perform_later(b.id) }
  end

  private

  def coincheck_client
    @coincheck_client || CoincheckClient.new
  end
end
