class DollcostAverageBot < Bot
  validates :level_base, presence: true
  validates :level_slope, presence: true, numericality: { less_than: 0.0 }
  validates :dca_interval_unit, presence: true, inclusion: { in: Bot.dca_interval_units.keys }
  validates :dca_interval_value, presence: true, numericality: { greater_than: 0 }
  validates :dca_settlment_amount, presence: true

  def post_needs_to_order?(rate)
    # 完了判定
    if Float(rate) > thresh
      complete!
      return false
    end

    # 定期購入判定
    last_at = order_logs.order(created_at: 'desc').first&.created_at || created_at
    last_at = last_at.beginning_of_day

    # TODO: 積立間隔可変化
    # dca_interval = dca_interval_day.day + dca_interval_hour.hour + dca_interval_minute.minute
    # next_time = last_at - (last_at % dca_interval) + dca_interval
    next_time = last_at.tomorrow

    Time.zone.now >= next_time
  end

  def post_order
    # Dummy
    logger.info 'Do Order!'
    # TODO: 成行き買い
  end

  def interval
    case dca_interval_unit
    when 'day'
      dca_interval_value.day
    when 'hour'
      dca_interval_value.hour
    when 'minute'
      dca_interval_value.minute
    else
      raise 'Funding interval calcuration error'
    end
  end
end
