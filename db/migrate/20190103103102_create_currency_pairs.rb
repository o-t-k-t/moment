class CreateCurrencyPairs < ActiveRecord::Migration[5.2]
  def change
    create_table :currency_pairs do |t|
      t.string :name, limit: 255, null: false
      t.string :key_currency, limit: 64, null: false
      t.string :settlement_currency, limit: 64, null: false
    end
  end
end
