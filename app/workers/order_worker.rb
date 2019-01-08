class OrderWorker
  include Sidekiq::Worker

  def perform(bid)
    # unless TransactionLog.exists?(job_id: jid)
    b = Bot.find(bid)

    logger.info "Before oder #{b.class}-#{b.id} status: #{b.status}"
    b.order
    logger.info "After oder #{b.class}-#{b.id} float_ratestatus: #{b.status}"

    # logger.info b.order
    # end
    # BotMailer.transaction_mail(name, email).deliver
    # TransactionLog.create(job_id: jid, bot_id: bid)
  end
end
