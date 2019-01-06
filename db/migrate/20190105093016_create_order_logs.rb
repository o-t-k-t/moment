class CreateOrderLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :order_logs do |t|
      t.references :bot, foreign_key: true, null: false
      t.references :currency_pair, foreign_key: true, null: false
      t.string :job_id, null: false, index: true
      t.text :message, null: false

      t.timestamps
    end
  end
end
