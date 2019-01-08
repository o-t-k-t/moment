class RemoveDcaIntervalFromBots < ActiveRecord::Migration[5.2]
  def change
    remove_column :bots, :dca_interval_day, :integer
    remove_column :bots, :dca_interval_hour, :integer
    remove_column :bots, :dca_interval_minute, :integer
  end
end
