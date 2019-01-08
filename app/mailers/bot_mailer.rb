class BotMailer < ApplicationMailer
  def complete_mail(bot)
    @bot = bot.decorate

    mail to: bot.user.email, subject: "Bot #{bot.id}が動作完了しました"
  end
end
