class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.text :description
      t.datetime :due_date
      t.boolean :completed
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
