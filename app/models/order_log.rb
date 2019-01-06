class OrderLog < ApplicationRecord
  belongs_to :bot
  belongs_to :currency_pair

  validates :currency_pair, presence: true
  validates :job_id, presence: true
  validates :message, presence: true
end
