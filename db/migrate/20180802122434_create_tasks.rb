class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.integer :meeting_id
      t.text :description
      t.datetime :due_date
      t.string :status
      t.string :flag

      t.timestamps
    end
  end
end
