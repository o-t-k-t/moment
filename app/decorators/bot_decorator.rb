class BotDecorator < Draper::Decorator
  delegate_all

  def status
    case object.status
    when 'running' then '稼働中'
    when 'pending' then '停止中'
    when 'completed' then '動作完了'
    end
  end

  def created_at
    "#{I18n.l(object.created_at, format: :long)}"
  end

  def strategy
    case object
    when DollcostAverageBot
      I18n.t('dca_bots.strategy')
    when TrailingStopBot
      I18n.t('trailing_stop_bots.strategy')
    else
      raise "Unsupported class #{object.class}"
    end
  end

  def description
    case object
    when DollcostAverageBot
      I18n.t(
        'dca_bots.description',
        interval: interval,
        key: currency_pair.key_currency,
        amount: dca_settlment_amount
      )
    when TrailingStopBot
      I18n.t(
        'trailing_stop_bots.description',
        pair: currency_pair.name,
        amount: ts_key_amount
      )
    else
      raise "Unsupported class #{object.class}"
    end
  end

  def interval
    return I18n.t('dca_bots.day', day: object.dca_interval_day) if object.dca_interval_day != 0
    return I18n.t('dca_bots.hour', hour: object.dca_interval_hour) if object.dca_interval_hour != 0
    return I18n.t('dca_bots.minute', minute: object.dca_interval_minute) if object.dca_interval_minute
  end
end
