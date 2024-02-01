class ReAddStatusToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :status, :integer
  end
end
