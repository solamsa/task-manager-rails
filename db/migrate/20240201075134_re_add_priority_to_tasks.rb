class ReAddPriorityToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :priority, :integer
  end
end
