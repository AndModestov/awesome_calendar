class RemoveRepeatTillDateFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :repeat_till_date, :datetime
  end
end
