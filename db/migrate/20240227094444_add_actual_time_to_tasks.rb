class AddActualTimeToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :actual_time, :integer
    change_column_default :tasks, :actual_time, nil
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE OR REPLACE FUNCTION update_actual_time()
          RETURNS TRIGGER AS $$
          BEGIN
            IF NEW.status = 2 THEN
              NEW.actual_time = EXTRACT(EPOCH FROM (NEW.completed_at - NEW.inprogress_at));
            ELSE
              NEW.actual_time = 0;
            END IF;
            RETURN NEW;
          END;
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER update_actual_time_trigger
          BEFORE INSERT OR UPDATE ON tasks
          FOR EACH ROW EXECUTE FUNCTION update_actual_time();
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP TRIGGER IF EXISTS update_actual_time_trigger ON tasks;
          DROP FUNCTION IF EXISTS update_actual_time();
        SQL
      end
    end
  end
end
