class RemoveStartAtFromBot < ActiveRecord::Migration[5.2]
  def change
    remove_column :bots, :start_at, :datetime
  end
end
