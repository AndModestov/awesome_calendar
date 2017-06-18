class AddRepeatToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :repeat, :integer, default: 0
    add_column :events, :repeat_till_date, :datetime
  end
end
