class Bot < ApplicationRecord
  include AASM

  belongs_to :currency_pair
  has_many :order_logs, dependent: :nullify

  # validates :currency_pair_id, presence: true
  # validates :status, presence: true

  aasm column: 'status' do
    state :running, initial: true
    state :pending, :completed

    event :pend do
      transitions from: :running, to: :pending
    end

    event :resume do
      transitions from: :pending, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed
    end
  end

  # 注文要否・実行のTemplate Method
  def needs_to_order?(rate)
    return false unless status == 'running'
    return false unless in_execution_period?

    post_needs_to_order?(rate)
  end

  def order(client)
    return unless status == 'running'
    return unless in_execution_period?

    post_order(client)
  end
  # このガード節DRYじゃないが、拡張性必要なのでこのままでいい

  private

  def post_needs_to_order?(_rate)
    raise 'No Implementation'
  end

  def post_order(_client)
    raise 'No Implementation'
  end

  def in_execution_period?
    start_at && Time.zone.now >= start_at
  end

  # 具象クラス向けメソッド
  def coincheck_client
    @coincheck_client || CoincheckClient.new(ENV['API_KEY'], ENV['SECRET_KEY'])
  end

  def thresh
    level_base + (Time.zone.now - start_at) * level_slope
  end
end
