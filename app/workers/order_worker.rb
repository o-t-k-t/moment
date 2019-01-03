class OrderWorker
  include Sidekiq::Worker

  def perform(bid)
    # unless TransactionLog.exists?(job_id: jid)
    Bot.find(bid).order(coincheck_client)
    # end
    # BotMailer.transaction_mail(name, email).deliver
    # TransactionLog.create(job_id: jid, bot_id: bid)
  end
end
