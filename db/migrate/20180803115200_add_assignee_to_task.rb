class AddAssigneeToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :assignee_id, :integer
    add_column :tasks, :assigner_id, :integer
  end
end
