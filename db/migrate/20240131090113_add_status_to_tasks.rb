class AddStatusToTasks < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TYPE task_status AS ENUM ('todo', 'inprogress', 'complete');
    SQL
    change_column :tasks, :status, :task_status
  end

  def down
    remove_column :tasks, :status
    execute <<-SQL
      DROP TYPE tasks_status;
    SQL
  end
end
