class TrailingStopBot < Bot
  validates :level_base, presence: true
  validates :level_slope, presence: true, numericality: { greater_than: 0.0 }
  validates :ts_key_amount, presence: true

  # 監視開始から指定レートで切り上げ続ける期待価格に実価格が足りなくなった時、売る
  def post_needs_to_order?(rate)
    Float(rate) <= thresh
  end

  def post_order(job_id, timestamp)
    req = coincheck_client(timestamp).create_orders(
      order_type: 'market_sell',
      amount: ts_key_amount.to_s,
      pair: currency_pair.name
    )
    res = JSON.parse(req.body)

    msg =
      if res['success']
        "#{currency_pair.name}を#{ts_key_amount}#{currency_pair.key_currency}購入しました"
      else
        "#{currency_pair.name}を#{ts_key_amount}#{currency_pair.key_currency}購入しましたが、「#{res['error']}」となりました"
      end

    order_logs.create(job_id: job_id, message: msg, currency_pair_id: currency_pair.id)

    complete!
  end

  def post_giveup
    # 1ジョブで成功しなければNonceが更新されるため多重注文防止を担保不可となるので閉塞する。
    complete!
  end
end
