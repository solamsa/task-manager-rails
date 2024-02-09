class AddEstimateToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks , :estimate, :interval
  end
end
