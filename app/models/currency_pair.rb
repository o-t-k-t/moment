class CurrencyPair < ApplicationRecord
  has_many :bots, dependent: :nullify
  has_many :order_logs, dependent: :nullify

  validates :name, presence: true
  validates :key_currency, presence: true
  validates :settlement_currency, presence: true

  before_destroy :require_bots_and_order_logs_absence
  before_update :require_bots_and_order_logs_absence

  def require_bots_and_order_logs_absence
    errors.add(:bots, 'が存在する通貨ペアは改変できません') if bots.exists?
    errors.add(:order_logs, 'が存在する通貨ペアは改変できません') if order_logs.exists?

    throw :abort if errors.any?
  end
end
