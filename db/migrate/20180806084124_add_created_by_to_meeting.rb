class AddCreatedByToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :created_by_id, :integer
  end
end
