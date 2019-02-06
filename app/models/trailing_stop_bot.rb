class TrailingStopBot < Bot
  validates :level_base, presence: true
  validates :level_slope, presence: true, numericality: { greater_than: 0.0 }
  validates :ts_key_amount, presence: true

  # 監視開始から指定レートで切り上げ続ける期待価格に実価格が足りなくなった時、売る
  def post_needs_to_order?(rate)
    Float(rate) <= thresh
  end

  def post_order(_job_id, _timestamp)
    complete!
  end
end
