class TradingWorker < ApplicationWorker
  sidekiq_options retry: 0

  # 現在値を取得し、注文が必要なBot数分、注文ジョブをエンキュー
  def perform(*_args)
    res = coincheck_client.read_rate
    rate = JSON.parse(res.body).fetch('rate')

    logger.info "BTCJPY #{rate}"

    Bot.in_running
       .find_each
       .tap { |bots| bots.each { |b| logger.info "Poll #{b.class}-#{b.id} #{b.status}" } }
       .select { |b| b.needs_to_order?(rate) }
       .each do |b|
         logger.info "Dispatch #{b.class}-#{b.id}"
         OrderWorker.perform_async(b.id, (Time.now.to_f * 1_000_000).to_i)
       end
  end

  private

  def coincheck_client
    @coincheck_client ||= CoincheckClient.new
  end
end
