class AddDcaIntervalToBots < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :dca_interval_unit, :integer
    add_column :bots, :dca_interval_value, :integer
  end
end
