class ChangeDataTypeOfPriorityInTasks < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      CREATE TYPE task_priority AS ENUM ('low', 'medium', 'high');
    SQL
    execute <<-SQL
      ALTER TABLE tasks
      ALTER COLUMN priority
      TYPE task_priority
      USING priority::task_priority;
    SQL
  end

  def down
    remove_column :tasks, :priority
    execute <<-SQL
      DROP TYPE tasks_priority;
    SQL
  end
end
