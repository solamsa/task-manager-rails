class AddStartedAtToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :inprogress_at, :datetime
    change_column_default :tasks, :inprogress_at, nil
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE OR REPLACE FUNCTION update_inprogress_at()
          RETURNS TRIGGER AS $$
          BEGIN
            IF NEW.status = 1 THEN
              NEW.inprogress_at = CURRENT_TIMESTAMP;
            ELSE
              NEW.inprogress_at = NULL;
            END IF;
            RETURN NEW;
          END;
          $$ LANGUAGE plpgsql;

          CREATE TRIGGER update_inprogress_at_trigger
          BEFORE INSERT OR UPDATE ON tasks
          FOR EACH ROW EXECUTE FUNCTION update_inprogress_at();
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP TRIGGER IF EXISTS update_inprogress_at_trigger ON tasks;
          DROP FUNCTION IF EXISTS update_inprogress_at();
        SQL
      end
    end
  end
end
