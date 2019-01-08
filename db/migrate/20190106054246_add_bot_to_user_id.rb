class AddBotToUserId < ActiveRecord::Migration[5.2]
  def change
    add_reference :bots, :user, foreign_key: true, null: false
  end
end
