class OrderWorker
  include Sidekiq::Worker

  def perform(bid)
    # unless TransactionLog.exists?(job_id: jid)
    b = Bot.find(bid)

    logger.info "Before oder #{b.class}-#{b.id} status: #{b.status}"
    b.order(jid)
    logger.info "After oder #{b.class}-#{b.id} float_ratestatus: #{b.status}"
  end
end
