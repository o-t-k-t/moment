class DollcostAverageBot < Bot
  # 上位単位の公倍数から任意に抽出。
  # 定時処理の起動間隔として扱う。(処理のたびにこの時間後にスケージュリングするのとは異なる)
  DAY_INTERVALS = [0, 1, 2, 4, 7].freeze
  HOUR_INTERVALS = [0, 1, 3, 6, 12].freeze
  MINUTE_INTERVALS = [0, 1, 3, 5, 10, 15, 30].freeze

  validates :level_base, presence: true
  validates :level_slope, presence: true, numericality: { less_than: 0.0 }
  validates :dca_interval_day, presence: true, inclusion: { in: DAY_INTERVALS }
  validates :dca_interval_hour, presence: true, inclusion: { in: HOUR_INTERVALS }
  validates :dca_interval_minute, presence: true, inclusion: { in: MINUTE_INTERVALS }
  validates :dca_settlment_amount, presence: true

  def post_needs_to_order?(rate)
    # 完了判定
    if rate > thresh
      complete
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
    puts coincheck_client.read_balance.body
    # TODO: 成行き買い
  end
end
