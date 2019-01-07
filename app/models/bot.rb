class Bot < ApplicationRecord
  include AASM

  enum dca_interval_unit: { day: 0, hour: 1, minute: 2 }

  belongs_to :currency_pair
  belongs_to :user
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

    post_needs_to_order?(rate)
  end

  def order(client)
    return unless status == 'running'

    post_order(client)
  end
  # このガード節DRYじゃないが、拡張性必要なのでこのままでいい

  def self.make(bot_params)
    case bot_params[:type]
    when 'DollcostAverageBot'
      DollcostAverageBot.new(bot_params)
    when 'TrailingStopBot'
      TrailingStopBot.new(bot_params)
    end
  end

  private

  def post_needs_to_order?(_rate)
    raise 'No Implementation'
  end

  def post_order(_client)
    raise 'No Implementation'
  end

  # 具象クラス向けメソッド
  def coincheck_client
    @coincheck_client || CoincheckClient.new(ENV['API_KEY'], ENV['SECRET_KEY'])
  end

  def thresh
    threah_at(Time.zone.now)
  end

  def threah_at(datetime)
    level_base + (datetime - created_at) * level_slope
  end
end
