class OrderWorker
  include Sidekiq::Worker

  def perform(bid)
    # unless TransactionLog.exists?(job_id: jid)
    b = Bot.find(bid)

    logger.info "Before oder #{b.class}-#{b.id} status: #{b.status}"
    b.order
    logger.info "After oder #{b.class}-#{b.id} float_ratestatus: #{b.status}"

    BotMailer.complete_mail(b).deliver
  end
end
