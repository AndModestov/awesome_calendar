class AddEndDateToEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :date

    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime

    add_index :events, [:start_time, :end_time]
  end
end
