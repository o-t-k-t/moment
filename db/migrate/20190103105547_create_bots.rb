class CreateBots < ActiveRecord::Migration[5.2]
  def change
    create_table :bots do |t|
      t.string :type, null: false, index: true
      t.references :currency_pair, null: false, index: true
      t.string :status, null: false
      t.datetime :start_at, null: false
      t.float :level_base
      t.float :level_slope
      t.integer :dca_interval_day
      t.integer :dca_interval_hour
      t.integer :dca_interval_minute
      t.float :dca_settlment_amount
      t.float :ts_key_amount

      t.timestamps null: false
    end
  end
end
