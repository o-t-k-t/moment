class DollcostAverageBot < Bot
  ACCEPTABLE_INTERVALS = {
    'day': [1, 3, 7].freeze,
    'hour': [1, 2, 3, 4, 6, 12].freeze,
    'minute': [1, 2, 3, 4, 5, 6, 10, 12, 15, 20, 30].freeze
  }.freeze

  validates :level_base, presence: true
  validates :level_slope, presence: true, numericality: { less_than: 0.0 }
  validates :dca_interval_unit, presence: true, inclusion: { in: Bot.dca_interval_units.keys }
  validates :dca_interval_value, presence: true
  validates :dca_settlment_amount, presence: true

  validate :requre_rounded_inerval

  def post_needs_to_order?(rate)
    # 完了判定
    if Float(rate) > thresh
      complete!
      BotMailer.complete_mail(self).deliver
      return false
    end

    # 定期購入判定
    # 前回購入時刻取得
    last_order_at = (order_logs.order(created_at: 'desc').first&.created_at || created_at).to_i

    # 今回購入の開始時刻を特定
    interval = dca_interval_value.to_i.send(dca_interval_unit)
    now = Time.zone.now.to_i
    order_need_from = now - (now % interval)

    # 前回購入が今回の購入開始時刻より過去なら、購入が必要
    last_order_at < order_need_from
  end

  def post_order(job_id, timestamp)
    req = coincheck_client(timestamp).create_orders(
      order_type: 'market_buy',
      market_buy_amount: dca_settlment_amount.to_s,
      pair: currency_pair.name
    )
    res = JSON.parse(req.body)

    msg =
      if res['success']
        "#{currency_pair.name}を#{dca_settlment_amount}#{currency_pair.settlement_currency}購入しました"
      else
        "#{currency_pair.name}を#{dca_settlment_amount}#{currency_pair.settlement_currency}購入しましたが、「#{res['error']}」となりました"
      end

    order_logs.create(job_id: job_id, message: msg, currency_pair_id: currency_pair.id)
  end

  def post_giveup
    # NOP
  end

  private

  def requre_rounded_inerval
    return if dca_interval_value.in?(ACCEPTABLE_INTERVALS[dca_interval_unit.to_sym])

    case dca_interval_unit
    when 'day'
      errors.add(:dca_interval_value, 'は1日, 3日, 7日以外選択できません ')
    when 'hour'
      errors.add(:dca_interval_value, 'は24を割り切れる値しか選べません')
    when 'minute'
      errors.add(:dca_interval_value, 'は60を割り切れる値しか選べません')
    end
  end
end
