class OrderWorker < ApplicationWorker
  sidekiq_options retry: 2

  def perform(bid, timestamp)
    b = Bot.find(bid)

    logger.info "Before oder #{b.class}-#{b.id} status: #{b.status}"
    b.order(jid, timestamp)
    logger.info "After oder #{b.class}-#{b.id} float_ratestatus: #{b.status}"
  end
end
